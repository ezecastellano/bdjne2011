package ubadb.apps.bufferManagement;

import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import ubadb.common.PageId;
import ubadb.common.TableId;
import ubadb.components.bufferManager.BufferManager;
import ubadb.components.bufferManager.BufferManagerImpl;
import ubadb.components.bufferManager.bufferPool.BufferPool;
import ubadb.components.bufferManager.bufferPool.SingleBufferPool;
import ubadb.components.bufferManager.bufferPool.replacementStrategies.PageReplacementStrategy;
import ubadb.components.bufferManager.bufferPool.replacementStrategies.fifo.FIFOReplacementStrategy;
import ubadb.components.bufferManager.bufferPool.replacementStrategies.usage.LRUReplacementStrategy;
import ubadb.components.bufferManager.bufferPool.replacementStrategies.usage.MRUReplacementStrategy;
import ubadb.components.diskManager.DiskManager;

public class BufferManagementEvaluator
{
	private static final int MAX_BUFFER_POOL_SIZE = 4;
	private static final int PAUSE_BETWEEN_REFERENCES	= 50;
	
	public static void main(String[] args) throws Exception
	{
	    Map<String, PageReplacementStrategy> strategies = new LinkedHashMap<String, PageReplacementStrategy>();
	    strategies.put("FIFO", new FIFOReplacementStrategy());
	    strategies.put("LRU", new LRUReplacementStrategy());
	    strategies.put("MRU", new MRUReplacementStrategy());

	    List<PageReferenceTrace> traces = generateTraces();
	    
	    int i = 1;
	    for (PageReferenceTrace trace : traces) {
	        System.out.println("----- Trace " + i);
	        for (Entry<String, PageReplacementStrategy> entry : strategies.entrySet()) {
	            String strategyName = entry.getKey();
                DiskManagerFaultCounterMock diskManagerFaultCounterMock = new DiskManagerFaultCounterMock();
                BufferManager bufferManager = createBufferManager(diskManagerFaultCounterMock, entry.getValue());
                double hitRate = calculateHitRate(bufferManager, trace, diskManagerFaultCounterMock);
                
                System.out.println(strategyName + ": " + hitRate);
            }
            i++;
        }
	}

	private static double calculateHitRate(BufferManager bufferManager, PageReferenceTrace trace, 
                        DiskManagerFaultCounterMock diskManagerFaultCounterMock) throws Exception {
        int requestsCount = 0;
        
        for(PageReference pageReference : trace.getPageReferences())
        {
            //Pause references to have different dates in LRU and MRU
            Thread.sleep(PAUSE_BETWEEN_REFERENCES);
            
            switch(pageReference.getType())
            {
                case REQUEST:
                {
                    bufferManager.readPage(pageReference.getPageId());
                    requestsCount++;
                    break;
                }
                case RELEASE:
                {
                    bufferManager.releasePage(pageReference.getPageId());
                    break;
                }
            }
        }
        
        int faultsCount = diskManagerFaultCounterMock.getFaultsCount();
        return calculateHitRate(faultsCount, requestsCount);
	}
	
	private static double calculateHitRate(int faults, int requests)
	{
		return (double)(requests - faults)/(double)requests;
	}

	private static PageReferenceTrace generateTrace()
	{
		PageReferenceTrace trace = new PageReferenceTrace();
		
		trace.addPageReference(new PageReference(new PageId(0, new TableId("a")), PageReferenceType.REQUEST));
		trace.addPageReference(new PageReference(new PageId(0, new TableId("a")), PageReferenceType.RELEASE));
		trace.addPageReference(new PageReference(new PageId(1, new TableId("a")), PageReferenceType.REQUEST));
		trace.addPageReference(new PageReference(new PageId(1, new TableId("a")), PageReferenceType.RELEASE));
		trace.addPageReference(new PageReference(new PageId(1, new TableId("a")), PageReferenceType.REQUEST));
		trace.addPageReference(new PageReference(new PageId(1, new TableId("a")), PageReferenceType.RELEASE));
		
		return trace;
	}

	private static List<PageReferenceTrace> generateTraces() {
	    PageReferenceTraceGenerator traceGenerator = new PageReferenceTraceGenerator();
	    return Arrays.asList(new PageReferenceTrace[]{
	        generateTrace(),
	        traceGenerator.generateFileScan("A", 1, 20),
	        traceGenerator.generateFileScan("A", 1, 100),
	        traceGenerator.generateIndexScanClustered("A", 3, 0, 20),
	        traceGenerator.generateIndexScanClustered("A", 3, 0, 100),
	        traceGenerator.generateIndexScanUnclustered("A", 3, 0, 20),
	        traceGenerator.generateIndexScanUnclustered("A", 3, 0, 100),
	        traceGenerator.generateBNLJ("A", 2, "B", 10, 4)
	    });
	}
	
	private static BufferManager createBufferManager(DiskManager diskManager, PageReplacementStrategy pageReplacementStrategy)
	{
		BufferPool basicBufferPool = new SingleBufferPool(MAX_BUFFER_POOL_SIZE, pageReplacementStrategy);
		
		BufferManager bufferManager = new BufferManagerImpl(diskManager, basicBufferPool);
		return bufferManager;
	}
}
