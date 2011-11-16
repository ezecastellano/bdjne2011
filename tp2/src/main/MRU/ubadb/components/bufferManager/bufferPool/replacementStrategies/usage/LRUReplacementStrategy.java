package ubadb.components.bufferManager.bufferPool.replacementStrategies.usage;

import ubadb.components.bufferManager.bufferPool.BufferFrame;
import ubadb.components.bufferManager.bufferPool.replacementStrategies.PageReplacementStrategy;

/**
 * {@link PageReplacementStrategy} that chooses the least recently used frame as the victim.
 * 
 */
public class LRUReplacementStrategy extends RecentUsageReplacementStrategy implements PageReplacementStrategy {

    /** @see FrameComparisonReplacementStrategy#shoudReplace(BufferFrame, BufferFrame) */
    @Override
    protected boolean shoudReplace(BufferFrame currentVictim, BufferFrame frame) {
        TrackedUsageBufferFrame current = (TrackedUsageBufferFrame) currentVictim;
        TrackedUsageBufferFrame other = (TrackedUsageBufferFrame) frame;
        return other.getLastReferenceDate().before(current.getLastReferenceDate());
    }

}
