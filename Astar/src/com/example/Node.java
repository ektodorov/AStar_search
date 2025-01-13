package com.example;

public class Node {
	
	public static final int STATE_NOT_VISITED = 0;
	public static final int STATE_OPEN = 1;
	public static final int STATE_CLOSED = 2;
	
	private Point location;
	private Node parent;
	private float F;
	private float G;
	private float H;
	private int state = STATE_NOT_VISITED;
	
	public Node() {
		super();
	}
	
	public Node(Node aParent) {
		parent = aParent;
	}
	
	public Node(Node aParent, Point aDestination, float aMoveCost) {
		parent = aParent;
		setF(aDestination, aMoveCost);
	}
	
	/**
	 * Using Manhattan heuristic approximation - difference in current location x, y and destination x, y
	 */
	public void setF(Point aDestination, float aMoveCost) {
		G = parent.getG() + aMoveCost;
		H = Math.abs((location.x - aDestination.x) + (location.y - aDestination.y));
		F = G + H;
	}
	
	public Point getLocation() {
		return location;
	}
	public void setLocation(Point location) {
		this.location = location;
	}
	public Node getParent() {
		return parent;
	}
	public void setParent(Node parent) {
		this.parent = parent;
	}
	public float getF() {
		return F;
	}
	public void setF(float f) {
		F = f;
	}
	public float getG() {
		return G;
	}
	public void setG(float g) {
		G = g;
	}
	public float getH() {
		return H;
	}
	public void setH(float h) {
		H = h;
	}
	public int getState() {
		return state;
	}
	public void setState(int state) {
		this.state = state;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((location == null) ? 0 : location.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Node other = (Node) obj;
		if (location == null) {
			if (other.location != null)
				return false;
		} else if (!location.equals(other.location))
			return false;
		return true;
	}

	@Override
	public String toString() {
		return "Node [location=" + location + ", parent=" + parent + ", F=" + F + ", G=" + G + ", H=" + H + ", state="
				+ state + "]";
	}	

	
}
