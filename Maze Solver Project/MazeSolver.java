/* Class to implement a Maze solver */

public abstract class MazeSolver {
	
	public static Square solve(Maze maze, SearchWorklist wl) {
		SearchWorklist workList = wl;
		Square[][] contents = maze.contents;
		Square curSquare = maze.start;
		workList.add(curSquare);
		curSquare.visit();
		while (!workList.isEmpty()) {
			curSquare = workList.remove();
			if (curSquare.equals(maze.finish)) {
				return curSquare;
			}
			else {
				int i = curSquare.getRow();
				int j = curSquare.getCol();
						
				Square northSquare = contents[i][j];
				Square southSquare = contents[i][j];
				Square eastSquare = contents[i][j];
				Square westSquare = contents[i][j];
				
				//NORTH
				if (availableNeighbor(contents, northSquare, i - 1, j) == true) {
					northSquare = contents[i - 1][j];
					northSquare.visit();
					northSquare.setPrevious(curSquare);
					workList.add(northSquare);
						}
				//SOUTH
				if (availableNeighbor(contents, southSquare, i + 1, j) == true) {
					southSquare = contents[i + 1][j];
					southSquare.visit();
					southSquare.setPrevious(curSquare);
					workList.add(southSquare);
						}
				//EAST
				if (availableNeighbor(contents, eastSquare, i , j + 1) == true) {
					eastSquare = contents[i][j + 1];
					eastSquare.visit();
					eastSquare.setPrevious(curSquare);
					workList.add(eastSquare);
						}
				//WEST
				if (availableNeighbor(contents, westSquare, i , j - 1) == true) {
					westSquare = contents[i][j - 1];
					westSquare.visit();	
					westSquare.setPrevious(curSquare);
					workList.add(westSquare);
						}
					}
				}
		return null;
	}

	/* Add any helper methods you want */
	public static boolean availableNeighbor(Square[][] contents, Square s, int rowOffset, int colOffset) {
		Square curSquare = s;
		for (int i = curSquare.getRow(); i < contents.length; i ++) {
			for (int j = curSquare.getCol(); j < contents[0].length; j++) {
				if ((0 <= rowOffset) && (rowOffset < contents.length) &&
					(0 <= colOffset) && (colOffset < contents[0].length)) {
					curSquare = contents[rowOffset][colOffset];
					if (curSquare.getIsWall() == false && curSquare.isVisited() == false) {
						return true;
					}
				}
			}
		}
		return false;
	}
}
