import java.util.ArrayList;


class StackWorklist implements SearchWorklist {
	
	ArrayList<Square> workListSt;
	
	public StackWorklist() {
		this.workListSt = new ArrayList<Square>();
	}
	
	//push
	public void add(Square c) {
		this.workListSt.add(c);
		
	}
	
	
	//pop
	public Square remove() {
		return this.workListSt.remove(this.workListSt.size() - 1);
	}
	
	public boolean isEmpty() {
		if (this.workListSt.size() == 0) {
			return true;
		}
		return false;
	}
}

class QueueWorklist implements SearchWorklist {
	
	ArrayList<Square> workListQ;
	
	public QueueWorklist() {
		this.workListQ = new ArrayList<Square>(); 
	}
	
	//enqueue
	public void add(Square c) {
		this.workListQ.add(c);
	}
	
	//dequeue
	public Square remove() {
		return this.workListQ.remove(0);
	}
	
	public boolean isEmpty() {
		if (this.workListQ.size() == 0) {
			return true;
		}
		return false;
	}
}

public interface SearchWorklist {
	void add(Square c);
	Square remove();
	boolean isEmpty();
}
