package com.example;

public class Main {
	
	public static void main(String[] args) {		
		AStar aStar = new AStar();
		aStar.setWorldYX(aStar.worldCreate(ConstantsA.sArrayWorld));
		//aStar.worldPrint();
		aStar.findPath();
		
		int count = aStar.getPath().size();
		for(int x = 0; x < count; x++) {
			Node node = aStar.getPath().get(x);
			//System.out.println(node);
			
			if(node.getLocation().equals(aStar.getDestination())) {break;}
			
			aStar.getWorldYX()[node.getLocation().y][node.getLocation().x] = "+";
		}
		
		aStar.worldPrint();
	}
}
