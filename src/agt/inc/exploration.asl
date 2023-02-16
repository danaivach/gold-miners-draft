/* Initial beliefs */
last_direction(null). // the agent initially believes that it hasn't moved previously 

/* 
 * Plans for exploring the environment The agent explores the environment by going near to a target position (X,Y).
 * To detect whether gold is placed in the target position is suffices that the agent visits an adjacent position.
*/

      
+cell(X,Y,gold) <- +gold(X,Y).

/* 
 * Plan for reacting to the creation of goal !explore(X,Y)
 * The agent strives to explore a position (X,Y) by going near the position (i.e. to an adjacent cell)
 * Triggering event: the creation of goal !explore(X,Y)
 * Context : the agent believes it is ready_to_explore
*/
@explore_plan
+!explore(X,Y) : ready_to_explore
  <- -near(_,_); // removes the belief that the agent is already near a position
     -last_direction(_); // removes the belief that the agent has previously moved in one of the 4 directions
     !go_near(X,Y). // creates the goal !go_near(X,Y)

/* 
 * Plan for reacting to the creation of goal !go_near(X,Y)
 * Triggering event: the creation of goal go_near(X,Y)
 * Context : the agent believes it is in position (SourceX,SourceY) which is adjacent to the target position (X,Y)
*/
@go_near_plan_1
+!go_near(X,Y) : (current_position(SourceX,SourceY) & jia.neighbour(SourceX,SourceY,X,Y))
   <- .print("I am at ", "(",SourceX,",", SourceY,")", " which is adjacent to (",X,",", Y,")");
      +near(X,Y). // adds a belief that the agent is near(X,Y)

/* 
 * Plan for reacting to the creation of goal !go_near(X,Y)
 * Triggering event: the creation of goal go_near(X,Y)
 * Context : the agent does not believe that it is near (X,Y)
*/
@go_near_plan_2
+!go_near(X,Y) : not near(X,Y)
   <- !next_step(X,Y); // creates the goal !next_step(X,Y)
      !go_near(X,Y). // creates the goal !go_near(X,Y)

/* 
 * Plan for reacting to the creation of goal !go_near(X,Y)
 * Triggering event: the creation of goal go_near(X,Y)
 * Context : true (the plan is always applicable)
*/
@go_near_plan_3
+!go_near(X,Y) : true
   <- !go_near(X,Y). // creates the goal !go_near(X,Y)

/* 
 * Plan for reacting to the creation of goal !next_step(X,Y)
 * The agent strives to achieve the goal by moving to one of the 4 directions (up/down/right/left)
 * Triggering event: the creation of goal next_step(X,Y)
 * Context : the agent believes that it has a position (SourceX, SourceY)
*/
@next_step_1
+!next_step(X,Y) : current_position(SourceX, SourceY) 
   <- jia.get_direction(SourceX, SourceY, X, Y, Direction); // action that unifies Direction with an action for moving to one of the 4 directions (up/down/right/left) for going from (SourceX,SourceY) towards (X,Y)
      -+last_direction(Direction); // updates the belief that the last direction of the agent is Direction 
      Direction. // action that moves the agent to one of the 4 directions (upd/down/right/left)

/* 
 * Plan for reacting to the creation of goal !next_step(X,Y)
 * Triggering event: the creation of goal next_step(X,Y)
 * Context : true (the plan is always applicable)
*/
@next_step_2
+!next_step(X,Y) : not current_position(_,_) 
   <- !next_step(X,Y). // creates the goal !next_step(X,Y)

/* 
 * Plan for reacting to the failure of goal !next_step(X,Y)
 * Triggering event: the failure of goal next_step(X,Y)
 * Context : true (the plan is always applicable)
*/
@next_step_3
-!next_step(X,Y) : true  
   <- -+last_direction(null); // updates (re-initializes) the belief that the agent hasn't moved previously 
      !next_step(X,Y). // creates a goal !next_step(X,Y)

/*TBA */
+end_of_simulation(S,_) : true
  <- .drop_all_desires;
     .abolish(gold(_,_));
     .abolish(picked(_));
     -+free;
     .print("-- END ",S," --").