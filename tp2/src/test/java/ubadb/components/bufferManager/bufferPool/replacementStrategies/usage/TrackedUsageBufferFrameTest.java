package ubadb.components.bufferManager.bufferPool.replacementStrategies.usage;

import static org.junit.Assert.assertTrue;

import org.junit.Test;

import ubadb.components.bufferManager.bufferPool.replacementStrategies.usage.TrackedUsageBufferFrame;
import ubadb.mocks.MockObjectFactory;
import ubadb.util.TestUtil;

public class TrackedUsageBufferFrameTest {

    @Test
    public void testPinReferenceDate() throws Exception
    {
        TrackedUsageBufferFrame bufferFrame0 = new TrackedUsageBufferFrame(MockObjectFactory.PAGE);
        TrackedUsageBufferFrame bufferFrame1 = new TrackedUsageBufferFrame(MockObjectFactory.PAGE);
        
        bufferFrame1.pin();
        Thread.sleep(TestUtil.PAUSE_INTERVAL); //Sleep to guarantee that both frames's last reference dates are different.
        bufferFrame0.pin();
        
        assertTrue(bufferFrame1.getLastReferenceDate().before(bufferFrame0.getLastReferenceDate()));
    }

    @Test
    public void testUnpinReferenceDate() throws Exception
    {
        TrackedUsageBufferFrame bufferFrame0 = new TrackedUsageBufferFrame(MockObjectFactory.PAGE);
        TrackedUsageBufferFrame bufferFrame1 = new TrackedUsageBufferFrame(MockObjectFactory.PAGE);
        
        bufferFrame1.pin();
        Thread.sleep(TestUtil.PAUSE_INTERVAL); //Sleep to guarantee that both frames's last reference dates are different.
        bufferFrame0.pin();
        Thread.sleep(TestUtil.PAUSE_INTERVAL);
        bufferFrame1.unpin();
        
        assertTrue(bufferFrame1.getLastReferenceDate().after(bufferFrame0.getLastReferenceDate()));
    }
    
}
