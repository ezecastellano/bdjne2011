package ubadb.components.bufferManager.bufferPool.replacementStrategies;

import static org.junit.Assert.assertEquals;

import java.util.Arrays;

import org.junit.Before;
import org.junit.Test;

import ubadb.components.bufferManager.bufferPool.BufferFrame;
import ubadb.exceptions.PageReplacementStrategyException;
import ubadb.mocks.MockObjectFactory;

/**
 * Common test for {@link PageReplacementStrategy} implementations.
 * 
 */
public abstract class BaseReplacementStrategyTest
{

    private PageReplacementStrategy strategy;
    
    @Before
    public void setUp()
    {
        strategy = createStrategy();
    }
    
    @Test(expected=PageReplacementStrategyException.class)
    public void testNoPageToReplace() throws Exception
    {
        BufferFrame frame0 = getStrategy().createNewFrame(MockObjectFactory.PAGE);
        BufferFrame frame1 = getStrategy().createNewFrame(MockObjectFactory.PAGE);
        
        frame0.pin();
        frame1.pin();
        
        getStrategy().findVictim(Arrays.asList(frame0,frame1));
    }
    
    @Test
    public void testOnlyOneToReplace() throws Exception
    {
        BufferFrame frame0 = getStrategy().createNewFrame(MockObjectFactory.PAGE);
        BufferFrame frame1 = getStrategy().createNewFrame(MockObjectFactory.PAGE);
        BufferFrame frame2 = getStrategy().createNewFrame(MockObjectFactory.PAGE);
        
        frame0.pin();
        frame1.pin();
        
        assertEquals(frame2,getStrategy().findVictim(Arrays.asList(frame0,frame1,frame2)));
    }
    
    protected PageReplacementStrategy getStrategy() 
    {
        return strategy;
    }
    
    protected abstract PageReplacementStrategy createStrategy();
    
}
