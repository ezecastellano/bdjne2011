package ubadb.components.bufferManager.bufferPool.replacementStrategies;

import java.util.Collection;

import ubadb.components.bufferManager.bufferPool.BufferFrame;
import ubadb.exceptions.PageReplacementStrategyException;

/**
 * {@link PageReplacementStrategy} that finds a victim by iterating
 * the collection of {@link BufferFrame}s and comparing them.
 * 
 * 
 */
public abstract class FrameComparisonReplacementStrategy implements PageReplacementStrategy 
{

    /** @see PageReplacementStrategy#findVictim(Collection) */
    public BufferFrame findVictim(Collection<BufferFrame> bufferFrames) throws PageReplacementStrategyException 
    {
        BufferFrame victim = null;
        
        for(BufferFrame bufferFrame : bufferFrames)
        {
            if(bufferFrame.canBeReplaced() && (victim == null || shoudReplace(victim, bufferFrame)))
            {
                victim = bufferFrame;
            }
        }
        
        if(victim == null)
            throw new PageReplacementStrategyException("No page can be removed from pool");
        else
            return victim;
    }

    /**
     * Compares a frame against the current candidate victim.
     * This method is called only for replaceable frames (the ones whose {@link BufferFrame#canBeReplaced()} 
     * method returns true) and when a current candidate exists (ie. there is no need to check if currentCandidate is null).
     * 
     * @param currentCandidate the current chosen candidate.
     * @param frame the frame to compare against the current candidate.
     * @return true if a the new frame should replace the current chosen candidate as the victim.
     */
    protected abstract boolean shoudReplace(BufferFrame currentVictim, BufferFrame frame);
    
}
