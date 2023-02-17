/* Initial beliefs */
last_direction(null). // the agent initially believes that it hasn't moved previously 

/* 
 * Plan for reacting to the addition of the belief near(X,Y) 
 * The plan is required during exploration so that when the agent reaches the location that it had decided to explore, 
 * it becomes again ready to explore another location
 * Triggering event: addition of belief near(X,Y)
 * Context : the agent believes it is ready to explore
 * Body: removes the old belief ready_to_explore and adds a new belief ready_to_explore
*/
@near_plan
+near(X,Y) : ready_to_explore <- 
   -+ready_to_explore. // removes the old belief ready_to_explore and adds a new belief ready_to_explore

/* 
 * Plan for reacting to the creation of goal !explore(X,Y)
 * The agent strives to explore a position (X,Y) by going near the position (i.e. to an adjacent cell)
 * Triggering event: creation of goal !explore(X,Y)
 * Context : the agent believes it is ready to explore
 * Body: removes believes about previous explorations and creates the goal to go near (X,Y)
*/
@explore_plan
+!explore(X,Y) : ready_to_explore <- 
   -near(_,_); // removes the belief that the agent is already near a position
   -last_direction(_); // removes the belief that the agent has previously moved in one of the 4 directions
   !go_near(X,Y). // creates the goal !go_near(X,Y)

/* 
 * Plan for reacting to the creation of goal !go_near(X,Y)
 * Triggering event: the creation of goal !go_near(X,Y)
 * Context: the agent believes it is in position (SourceX,SourceY) which is adjacent to the target position (X,Y)
 * Body: adds the belief that the agent is near (X,Y)
*/
@go_near_right_position_plan
+!go_near(X,Y) : current_position(SourceX,SourceY) & jia.neighbour(SourceX,SourceY,X,Y) <- 
   .print("I am at ", "(",SourceX,",", SourceY,")", " which is adjacent to (",X,",", Y,")");
   +near(X,Y). // adds a belief that the agent is near(X,Y)

/* 
 * Plan for reacting to the creation of goal !go_near(X,Y)
 * Triggering event: the creation of goal !go_near(X,Y)
 * Context: the agent believes it is in position (SourceX,SourceY) and the agent skipped its last movement (e.g. due to an abstacle)
 * Body: adds the belief that the agent is near (X,Y)
*/
@go_near_obstacle_plan
+!go_near(X,Y) : current_position(SourceX,SourceY) & last_dir(skip) <- 
   .print("I am at ", "(",SourceX,",", SourceY,")", " and I can't get to' (",X,",", Y,")");
   +near(X,Y).

/* 
 * Plan for reacting to the creation of goal !go_near(X,Y)
 * Triggering event: the creation of goal !go_near(X,Y)
 * Context : the agent does not believe that it is near (X,Y)
 * Body: creates the goal to make 1 more step towards (X,Y) and the goal to go near (X,Y)
*/
@go_near_wrong_position_plan
+!go_near(X,Y) : not near(X,Y) <- 
   !next_step(X,Y); // creates the goal !next_step(X,Y)
   !go_near(X,Y). // creates the goal !go_near(X,Y)

/* 
 * Plan for reacting to the creation of goal !go_near(X,Y)
 * Triggering event: the creation of goal !go_near(X,Y)
 * Context : true (the plan is always applicable)
 * Body: creates the goal to go near (X,Y)
*/
@go_near_generic_plan
+!go_near(X,Y) : true <- 
   !go_near(X,Y). // creates the goal !go_near(X,Y)

/* 
 * Plan for reacting to the creation of goal !next_step(X,Y)
 * The plan is required for moving to one of the 4 directions (up/down/right/left) towards (X,Y)
 * Triggering event: the creation of goal !next_step(X,Y)
 * Context: the agent believes that it is located at (SourceX, SourceY)
 * Body: computes and performs a directional action (up/down/right/left) towards (X,Y)
*/
@next_step_plan
+!next_step(X,Y) : current_position(SourceX, SourceY) <- 
   jia.get_direction(SourceX, SourceY, X, Y, Direction); // action that unifies Direction with an action for moving to one of the 4 directions (up/down/right/left) for going from (SourceX,SourceY) towards (X,Y)
   -+last_direction(Direction); // updates the belief that the last direction of the agent is Direction 
   Direction. // action that moves the agent to one of the 4 directions (up/down/right/left)


/* 
 * Plan for reacting to the creation of goal !next_step(X,Y)
 * The plan is required for moving to one of the 4 directions (up/down/right/left) towards (X,Y),
 * when the agent does not have a belief about its current location
 * Triggering event: the creation of goal !next_step(X,Y)
 * Context: the agent does not have a belief about its location
 * Body: creates goal !next_step(X,Y)
*/
@next_step_unknown_location_plan
+!next_step(X,Y) : not current_position(_,_) <- 
   !next_step(X,Y). // creates the goal !next_step(X,Y)

/* 
 * Plan for reacting to the deletion of goal !next_step(X,Y)
 * The plan is required for handling the failure of the goal !next_step(X,Y)
 * Triggering event: the deletion of goal !next_step(X,Y)
 * Context: true (the plan is always applicable)
 * Body: re-initializes the belief that the agent hasn't moved previosuly and creates goal !next_step(X,Y)
*/
@next_step_generic_plan
-!next_step(X,Y) : true  <- 
   -+last_direction(null); // updates (re-initializes) the belief that the agent hasn't moved previously 
   !next_step(X,Y). // creates goal !next_step(X,Y)

/* 
 * Plan for reacting to the addition of the belief end_of_simulation(S,_)
 * Triggering event: the addition of the belief end_of_simulation(S,_)
 * Context: true (the plan is always applicable)
 * Body: deletes goals and beliefs
*/
+end_of_simulation(S,_) : true <- 
   .drop_all_desires; // deletes all goals
   .abolish(gold(_,_)); // deletes believes about perceived gold nuggets
   .abolish(picked(_)); // deletes believes about picked gold nuggets
   -+ready_to_explore; // deletes the old belief ready_to_explore and adds a new belief ready_to_explore
   .print("-- END ",S," --").