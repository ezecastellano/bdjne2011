package ubadb.components.bufferManager.bufferPool.replacementStrategies.fifo;

import static org.junit.Assert.assertEquals;

import java.util.Arrays;

import org.junit.Test;

import ubadb.components.bufferManager.bufferPool.BufferFrame;
import ubadb.components.bufferManager.bufferPool.replacementStrategies.BaseReplacementStrategyTest;
import ubadb.components.bufferManager.bufferPool.replacementStrategies.PageReplacementStrategy;
import ubadb.mocks.MockObjectFactory;
import ubadb.util.TestUtil;


public class FIFOReplacementStrategyTest extends BaseReplacementStrategyTest
{

    /** @see BaseReplacementStrategyTest#createStrategy() */
    @Override
    protected PageReplacementStrategy createStrategy() {
        return new FIFOReplacementStrategy();
    }
	
	@Test
	public void testMultiplePagesToReplace() throws Exception
	{
		BufferFrame frame0 = getStrategy().createNewFrame(MockObjectFactory.PAGE);
		Thread.sleep(TestUtil.PAUSE_INTERVAL);	//Add a sleep so that frame dates are different
		BufferFrame frame1 = getStrategy().createNewFrame(MockObjectFactory.PAGE);
		Thread.sleep(TestUtil.PAUSE_INTERVAL);
		BufferFrame frame2 = getStrategy().createNewFrame(MockObjectFactory.PAGE);
		
		assertEquals(frame0,getStrategy().findVictim(Arrays.asList(frame0,frame1,frame2)));
	}

	@Test
	public void testMultiplePagesToReplaceButOldestOnePinned() throws Exception
	{
		BufferFrame frame0 = getStrategy().createNewFrame(MockObjectFactory.PAGE);
		Thread.sleep(TestUtil.PAUSE_INTERVAL);	//Add a sleep so that frame dates are different
		BufferFrame frame1 = getStrategy().createNewFrame(MockObjectFactory.PAGE);
		Thread.sleep(TestUtil.PAUSE_INTERVAL);
		BufferFrame frame2 = getStrategy().createNewFrame(MockObjectFactory.PAGE);
		
		frame0.pin();
		
		assertEquals(frame1,getStrategy().findVictim(Arrays.asList(frame0,frame1,frame2)));
	}

}
