package com.example;

public class ConstantsA {

	private ConstantsA() {
		super();
	}
	
	public static final String[] sArrayWorld = {
  			"***************",
  			"*     *       *",
  			"*             *",
  			"*             *",
  			"*       o     *",
  			"*             *",
  			"*             *",
  			"*** ******    *",
  			"*     *       *",
  			"*     *       *",
  			"*             *",
  			"*             *",
  			"*     *       *",
  			"*             *",
  			"*             *",
  			"*             *",
  			"*d    *       *",
  			"*             *",
  			"***************"};
	public static final String SYMBOL_WALL = "*";
	public static final String SYMBOL_SPACE = " ";
	public static final String SYMBOL_START = "o";
	public static final String SYMBOL_DESTINATION = "d";
	public static final int MOVE_COST = 1;
}
