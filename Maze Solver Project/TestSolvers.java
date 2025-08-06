import java.util.ArrayList;

/*
 * Write your JUnit tests here
 * Use the formatMaze() method to get nicer JUnit output
 */

import org.junit.Test;
import static org.junit.Assert.*;

public class TestSolvers {

	/* Helper method to compare two mazes */
	public void checkMaze(SearchWorklist wl, Maze startMaze, String[] expected) {
		Square s = MazeSolver.solve(startMaze, wl);
		if(expected == null) { assertNull(s); }
		else {
			ArrayList<Square> sp = startMaze.storePath();
			String actualStr = formatMaze(startMaze.showSolution(sp));
			String expectedStr = formatMaze(expected);
			assertEquals(expectedStr, actualStr);
		}
	}	

	/* Helper method to format String[] output as String */
	public String formatMaze(String[] arr) {
		String result = "";
		for (String s: arr)
			result += "\n"+s;
		return (result+"\n");
	}

	/* Add your own Worklist tests below */

	String[] qTest1Solution = new String[] {
			  "#___",
			  "**F_",
			  "S##_",
			  "____" };
	
	String[] stackTest1Solution = new String[] {
			  "#___",
			  "__F*",
			  "S##*",
			  "****" };
	/* ************** HINT ******************** 
	 * Use the helper methods to create simple
	 * tests that are easier to debug. 
	 */
	
	@Test
	public void queueTest1() {
		Maze qTest1 = new Maze(new String[] {
				  "#___",
				  "__F_",
				  "S##_",
				  "____" });
		QueueWorklist queue = new QueueWorklist();
		MazeSolver.solve(qTest1, queue);
		ArrayList<Square> qTest = qTest1.storePath();
		String[] qTester = qTest1.showSolution(qTest);
		assertArrayEquals(qTest1Solution, qTester);
	}
	@Test
	public void stackTest1() {
		Maze stackTest1 = new Maze(new String[] {
				  "#___",
				  "__F_",
				  "S##_",
				  "____" });
		StackWorklist stack = new StackWorklist();
		MazeSolver.solve(stackTest1, stack);
		ArrayList<Square> sTest = stackTest1.storePath();
		String[] sTester = stackTest1.showSolution(sTest);
		assertArrayEquals(stackTest1Solution, sTester);
	}
}



