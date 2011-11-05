package ubadb.components.bufferManager.bufferPool.replacementStrategies.usage;

import static org.junit.Assert.assertEquals;

import java.util.Arrays;

import org.junit.Test;

import ubadb.components.bufferManager.bufferPool.BufferFrame;
import ubadb.components.bufferManager.bufferPool.replacementStrategies.BaseReplacementStrategyTest;
import ubadb.components.bufferManager.bufferPool.replacementStrategies.PageReplacementStrategy;
import ubadb.components.bufferManager.bufferPool.replacementStrategies.usage.LRUReplacementStrategy;
import ubadb.mocks.MockObjectFactory;
import ubadb.util.TestUtil;

/**
 * Test for {@link LRUReplacementStrategy}
 * 
 */
public class LRUReplacementStrategyTest extends BaseReplacementStrategyTest {

    /** @see BaseReplacementStrategyTest#createStrategy() */
    @Override
    protected PageReplacementStrategy createStrategy() {
        return new LRUReplacementStrategy();
    }

    @Test
    public void testMultiplePagesToReplace() throws Exception
    {
        BufferFrame frame0 = getStrategy().createNewFrame(MockObjectFactory.PAGE);
        BufferFrame frame1 = getStrategy().createNewFrame(MockObjectFactory.PAGE);
        BufferFrame frame2 = getStrategy().createNewFrame(MockObjectFactory.PAGE);

        frame0.pin();
        frame1.pin();
        frame2.pin();
        
        frame0.unpin();
        Thread.sleep(TestUtil.PAUSE_INTERVAL);  //Add a sleep so that frame usage dates are different
        frame1.unpin();
        Thread.sleep(TestUtil.PAUSE_INTERVAL);
        frame2.unpin();
        
        assertEquals(frame0,getStrategy().findVictim(Arrays.asList(frame0,frame1,frame2)));
    }
    
}
