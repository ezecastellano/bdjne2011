package ubadb.components.bufferManager.bufferPool.replacementStrategies.fifo;

import ubadb.common.Page;
import ubadb.components.bufferManager.bufferPool.BufferFrame;
import ubadb.components.bufferManager.bufferPool.replacementStrategies.FrameComparisonReplacementStrategy;
import ubadb.components.bufferManager.bufferPool.replacementStrategies.PageReplacementStrategy;

public class FIFOReplacementStrategy extends FrameComparisonReplacementStrategy implements PageReplacementStrategy
{
    
    /** @see FrameComparisonReplacementStrategy#shoudReplace(BufferFrame, BufferFrame) */
    @Override
    protected boolean shoudReplace(BufferFrame currentVictim, BufferFrame frame) {
        //safe cast as we know all frames are of this type
        FIFOBufferFrame current = (FIFOBufferFrame) currentVictim;
        FIFOBufferFrame other = (FIFOBufferFrame) frame;
        
        return other.getCreationDate().before(current.getCreationDate());
    }

	public BufferFrame createNewFrame(Page page)
	{
		return new FIFOBufferFrame(page);
	}
}
