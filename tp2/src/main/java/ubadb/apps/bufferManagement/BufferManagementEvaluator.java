package ubadb.apps.bufferManagement;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Map.Entry;

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
	private static final int PAUSE_BETWEEN_REFERENCES	= 50;
	private static final PageReferenceTraceGenerator GENERATOR = new PageReferenceTraceGenerator();
    
	public static void main(String[] args) throws Exception
	{
	    Map<String, PageReplacementStrategy> strategies = new LinkedHashMap<String, PageReplacementStrategy>();
	    strategies.put("FIFO", new FIFOReplacementStrategy());
	    strategies.put("LRU", new LRUReplacementStrategy());
	    strategies.put("MRU", new MRUReplacementStrategy());
	    
	    if (checkTest("t1", args)) {
	        // tamaños de scan para filescan y index clustered
	        int[] pageCounts = {20, 50, 100};
	        fileScanTest(strategies, pageCounts);
	        testCaseIndexClustered(strategies, pageCounts);
	    }
	    
	    if (checkTest("t2", args)) {
	        // test index scan unclustered.
	        int[] bufferSizes = {4, 20, 80, 120};
	        int[] referenceCounts = {20, 50, 80, 100, 120};
	        testCaseIndexUnclustered(strategies, bufferSizes, referenceCounts);
	    }

	    if (checkTest("t3", args)) {
	        // cuántas veces se hará el filescan. es decir, cantidad de veces que se parte A en bloques
	        int[] iterations = {1, 2, 5, 10};
	        int blockSize = 2;
	        int bufferSize = 30;
	        testCaseBNLJ(strategies, iterations, blockSize, bufferSize);
	    }
	    
	    
	}

	/** Indica si el label está presente en los argumentos pasados al programa, para decidir qué pruebas correr. */
	private static boolean checkTest(String label, String[] args) {
	    for (String string : args) {
            if (string.equals(label)) return true;
        }
	    return false;
	}
	
	/**
	 * Ejecuta test para File Scan
	 * @param strategies estrategias a testear, identificadas por un label
	 * @param pageCounts serie de tamaños de archivo a escanear
	 * @throws Exception
	 */
	private static void fileScanTest(Map<String, PageReplacementStrategy> strategies,
	                                int[] pageCounts) throws Exception {
	    for (int pageCount : pageCounts) {
	        for (Entry<String, PageReplacementStrategy> entry : strategies.entrySet()) {
	            PageReferenceTrace trace = GENERATOR.generateFileScan("A", 0, pageCount);
	            double hitRate = run(entry.getValue(), trace, 20);
	            // OUTPUT: STRATEGY,PAGE_COUNT,HITRATE
	            System.out.println(entry.getKey() + "," + pageCount + "," + hitRate);
            }
        }
	}

	/**
     * Ejecuta test para Index Scan clustered
     * @param strategies estrategias a testear, identificadas por un label
     * @param pageCounts serie de tamaños de objeto a escanear
     * @throws Exception
     */
    private static void testCaseIndexClustered(Map<String, PageReplacementStrategy> strategies,
                                    int[] pageCounts) throws Exception {
        for (int pageCount : pageCounts) {
            for (Entry<String, PageReplacementStrategy> entry : strategies.entrySet()) {
                PageReferenceTrace trace = GENERATOR.generateIndexScanClustered("A", 3, 0, pageCount);
                double hitRate = run(entry.getValue(), trace, 20);
                // OUTPUT: STRATEGY,PAGE_COUNT,HITRATE
                System.out.println(entry.getKey() + "," + pageCount + "," + hitRate);
            }
        }
    }
	
	/**
	 * Ejecuta test para Index Scan Unclustered
	 * Se utiliza pageCount = 2*referenceCount, osea que se realizan pageCount/2 pedidos de página aleatorios.
	 * 
	 * @param strategies estrategias a testear, identificadas por un label
	 * @param generator generador de trazas
	 * @param bufferSizes serie de tamaños de buffer a probar
	 * @param referenceCounts serie de cantidad de referencias a generar en las trazas
	 * @throws Exception
	 */
	private static void testCaseIndexUnclustered(Map<String, PageReplacementStrategy> strategies, 
	                                int[] bufferSizes,
	                                int[] referenceCounts) throws Exception {
	    for (int bufferSize : bufferSizes) { // bufferSize
	        
	        for (int referenceCount : referenceCounts) { // strategy
	            PageReferenceTrace trace = GENERATOR.generateIndexScanUnclustered("A", 3, referenceCount, 2*referenceCount);
	            
	            for (Entry<String, PageReplacementStrategy> entry : strategies.entrySet()) { //trace
	                String strategyLabel = entry.getKey();
	                PageReplacementStrategy strategy = entry.getValue();
	                
                    double hitRate = run(strategy, trace, bufferSize);
                    
                    // Output: BUFFER_SIZE,STRATEGY,REFERENCE_COUNT,HIT_RATE
                    System.out.println(bufferSize + "," + strategyLabel + "," + referenceCount + "," + hitRate);
                }
	            
	        }
	        
        }
	}
	
	   /**
     * Corridas en donde la tabla inner es más grande que el espacio libre de buffer 
     * (es decir, el total - el espacio destinado a los bloques de la inner)
     * 
     * @param strategies
     * @throws Exception
     */
    private static void testCaseBNLJ(Map<String, PageReplacementStrategy> strategies, int[] iterations, 
                                    int blockSize, int bufferSize) throws Exception {
        for (int iterationsNumber : iterations) {
            for (int i = -10; i <= 10; i++) {
                int pagesInner = bufferSize - (blockSize) + i;
                PageReferenceTrace trace = GENERATOR.generateBNLJ("A", iterationsNumber * blockSize, "B", pagesInner, blockSize);
                for (Entry<String, PageReplacementStrategy> entry : strategies.entrySet()) {
                    double hitRate = run(entry.getValue(), trace, bufferSize);
                    // Output: ITERATIONS,DIFERENCIA,STRATEGY,HIT_RATE 
                    System.out.println(iterationsNumber + "," + i + "," + entry.getKey() + "," + hitRate);
                }
            }
        }
    }
	
	private static double run(PageReplacementStrategy strategy, PageReferenceTrace trace, int bufferSize) throws Exception {
        DiskManagerFaultCounterMock diskManagerFaultCounterMock = new DiskManagerFaultCounterMock();
        BufferManager bufferManager = createBufferManager(diskManagerFaultCounterMock, strategy, bufferSize);

        int requestCount = runTrace(bufferManager, trace);
        int faultsCount = diskManagerFaultCounterMock.getFaultsCount();
        return calculateHitRate(faultsCount, requestCount);
	}
	
	/**
	 * runs a {@link PageReferenceTrace}
	 * 
	 * @return requestCount.
	 */
	private static int runTrace(BufferManager bufferManager, PageReferenceTrace trace) throws Exception {
        int requestsCount = 0;
        
        for(PageReference pageReference : trace.getPageReferences())
        {
            //Pause references to have different dates
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
        
        return requestsCount;
	}
	
	private static double calculateHitRate(int faults, int requests)
	{
		return (double)(requests - faults)/(double)requests;
	}

	private static BufferManager createBufferManager(DiskManager diskManager, PageReplacementStrategy pageReplacementStrategy, int bufferPoolSize)
	{
		BufferPool basicBufferPool = new SingleBufferPool(bufferPoolSize, pageReplacementStrategy);
		
		BufferManager bufferManager = new BufferManagerImpl(diskManager, basicBufferPool);
		return bufferManager;
	}
}
