package ubadb.components.bufferManager.bufferPool.replacementStrategies.usage;

import ubadb.common.Page;
import ubadb.components.bufferManager.bufferPool.BufferFrame;
import ubadb.components.bufferManager.bufferPool.replacementStrategies.FrameComparisonReplacementStrategy;
import ubadb.components.bufferManager.bufferPool.replacementStrategies.PageReplacementStrategy;

/**
 * FrameComparisonReplacementStrategy that uses the last time a frame was references to choose a victim.
 * 
 */
public abstract class RecentUsageReplacementStrategy extends FrameComparisonReplacementStrategy {

    /** @see PageReplacementStrategy#createNewFrame(Page) */
    public BufferFrame createNewFrame(Page page) {
        return new TrackedUsageBufferFrame(page);
    }

}
