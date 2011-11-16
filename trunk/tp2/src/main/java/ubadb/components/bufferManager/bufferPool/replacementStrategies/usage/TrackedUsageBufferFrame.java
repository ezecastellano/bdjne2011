package ubadb.components.bufferManager.bufferPool.replacementStrategies.usage;

import java.util.Date;

import ubadb.common.Page;
import ubadb.components.bufferManager.bufferPool.BufferFrame;
import ubadb.exceptions.BufferFrameException;

/**
 * Buffer frame that keeps track of the last time the page was referenced
 * (via calls to {@link BufferFrame#pin()} and {@link BufferFrame#unpin()}).
 * 
 */
public class TrackedUsageBufferFrame extends BufferFrame {

    private Date lastReferenceDate;
    
    /** Creates the TrackedUsageBufferFrame. */
    public TrackedUsageBufferFrame(Page page) {
        super(page);
    }

    @Override
    public void pin() {
        super.pin();
        updateLastReferenceDate();
    }

    @Override
    public void unpin() throws BufferFrameException {
        super.unpin();
        updateLastReferenceDate();
    }

    /** @return the last time the frame was referenced. */
    public Date getLastReferenceDate() {
        return lastReferenceDate;
    }
    
    private void updateLastReferenceDate() {
        lastReferenceDate = new Date();
    }
}
