package com.example;

import java.util.ArrayList;

public class AStar {
	
	private String[][] mWorldYX;
	private ArrayList<Node> mArrayOpen;
	private ArrayList<Node> mArrayClosed;
	private ArrayList<Node> mArrayPath;
	private Point mDestination;
	
	public AStar() {
		super();
		mArrayOpen = new ArrayList<Node>();
		mArrayClosed = new ArrayList<Node>();
		mArrayPath = new ArrayList<Node>();
	}

	public void findPath() {
		mDestination = findDestination();
		if(mDestination == null) {throw new Error("Aborting there is no destination location set on the map");}
		Node nodeStart = getStartNode();
		if(nodeStart == null) {throw new Error("Aborting there is no start location set on the map");}
				
		Node nodeCurrent = null;
		mArrayOpen.add(nodeStart);
		while(mArrayOpen.size() > 0) {
			nodeCurrent = mArrayOpen.remove(0);
			
			if(nodeCurrent.getLocation().equals(mDestination)) {
				break;
			}
			
			ArrayList<Node> arrayNeighbours = getNeighbourNodes(nodeCurrent);
			
			int count = arrayNeighbours.size();
			for(int x = 0; x < count; x++) {
				Node nodeNeighbour = arrayNeighbours.get(x);
				if(mArrayClosed.contains(nodeNeighbour)) {
					continue;
				}
				if(mArrayOpen.contains(nodeNeighbour)) {
					float tempG = nodeCurrent.getG() + ConstantsA.MOVE_COST;
					float tempH = Math.abs((nodeNeighbour.getLocation().x - mDestination.x) + (nodeNeighbour.getLocation().y - mDestination.y));
					float tempF = tempG + tempH;
					if(tempF < nodeNeighbour.getF()) {
						nodeNeighbour.setParent(nodeCurrent);
						nodeNeighbour.setF(tempF);
					}
					continue;
				}
				
				nodeNeighbour.setParent(nodeCurrent);
				nodeNeighbour.setF(mDestination, ConstantsA.MOVE_COST);
				mArrayOpen.add(nodeNeighbour);
			}
			mArrayClosed.add(nodeCurrent);
		}
				
		while(nodeCurrent.getParent() != null) {
			mArrayPath.add(0, nodeCurrent);
			nodeCurrent = nodeCurrent.getParent();
		}
	}
	
	public String[][] worldCreate(String[] aArrayWorld) {
		String[][] arrayYX = new String[aArrayWorld.length][];
		for(int y = 0; y < aArrayWorld.length; y++) {	
			String currentItem = aArrayWorld[y];
			int count = currentItem.length();
			arrayYX[y] = new String[count];
			for(int x = 0; x < count; x++) {
				arrayYX[y][x] = currentItem.substring(x, x + 1);
		    }
		}
		
		return arrayYX;
	}
	
	public void worldPrint() {
		int height = mWorldYX.length;
		int width = mWorldYX[0].length;
		String strWorld = "";
		for(int y = 0; y < height; y++) {
			String row = "";
			for(int x = 0; x < width; x++) {
				row = row + mWorldYX[y][x];
			}
			strWorld = strWorld + row + "\n";
		}
		System.out.println(strWorld);
	}
	
	private Node getStartNode() {
		int width = mWorldYX.length;
		int height = mWorldYX[0].length;
		for(int x = 0; x < width; x++) {
			for(int y = 0; y < height; y++) {
				String symbol = mWorldYX[y][x];
				if(symbol.equals(ConstantsA.SYMBOL_START)) {
					Node node = new Node();
					node.setLocation(new Point(x, y));
//					node.setH(Math.abs((x - mDestination.x) + (y - mDestination.y)));
//					node.setF(node.getG() + node.getH());
					return node;
				}
			}
		}
		return null;
	}
	
	private Point findDestination() {
		int height = mWorldYX.length;
		int width = mWorldYX[0].length;
		for(int x = 0; x < width; x++) {
			for(int y = 0; y < height; y++) {
				String symbol = mWorldYX[y][x];
				if(symbol.equals(ConstantsA.SYMBOL_DESTINATION)) {
					Point point = new Point(x, y);
					return point;
				}
			}
		}
		return null;
	}
	
	private ArrayList<Node> getNeighbourNodes(Node aNode) {
		ArrayList<Node> arrayNodes = new ArrayList<Node>();
		
		int x = aNode.getLocation().x;
		int y = aNode.getLocation().y;
		
		//Moving in 4 directions - East, West, North, South
		//If we can move diagonally, we should add cases for - NorthEast, SouthEast, NorthWest, SouthWest
		if((x + 1) < mWorldYX[y].length) {
			String symbol = mWorldYX[y][x + 1];
			if(symbol.equals(ConstantsA.SYMBOL_SPACE) || symbol.equals(ConstantsA.SYMBOL_DESTINATION)) {
				Node node = new Node();
				node.setLocation(new Point(x + 1, y));
				arrayNodes.add(node);
			}
		}
		
		if((x - 1) >= 0) {
			String symbol = mWorldYX[y][x - 1];
			if(symbol.equals(ConstantsA.SYMBOL_SPACE) || symbol.equals(ConstantsA.SYMBOL_DESTINATION)) {
				Node node = new Node();
				node.setLocation(new Point(x - 1, y));
				arrayNodes.add(node);
			}
		}
		
		if((y + 1) < mWorldYX.length) {
			String symbol = mWorldYX[y + 1][x];
			if(symbol.equals(ConstantsA.SYMBOL_SPACE) || symbol.equals(ConstantsA.SYMBOL_DESTINATION)) {
				Node node = new Node();
				node.setLocation(new Point(x, y + 1));
				arrayNodes.add(node);
			}
		}
		
		if((y - 1) >= 0) {
			String symbol = mWorldYX[y - 1][x];
			if(symbol.equals(ConstantsA.SYMBOL_SPACE) || symbol.equals(ConstantsA.SYMBOL_DESTINATION)) {
				Node node = new Node();
				node.setLocation(new Point(x, y - 1));
				arrayNodes.add(node);
			}
		}
		
		return arrayNodes;
	}
	
	public String[][] getWorldYX() {return mWorldYX;}
	public void setWorldYX(String[][] aWorldYX) {mWorldYX = aWorldYX;}
	
	public ArrayList<Node> getPath() {return mArrayPath;}
	
	public Point getDestination() {return mDestination;}
}
