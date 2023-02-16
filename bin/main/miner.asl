// miner agent

/*
 * By Joao Leite
 * Based on implementation developed by Rafael Bordini, Jomi Hubner and Maicon Zatelli
 */

/* Initial beliefs */
ready_to_explore. // the miner initially believes that it is ready to explore the environment
mine_base(0,0). // the miner initially believes that the base of the mine is in position (0,0)

/* Initial goals */
!start. // the miner initially has the goal to start

/* 
 * Plan for achieving the goal !start 
 * Triggering event: Creation of goal !start
 * Context: true (the plan is always applicable)
*/
@start_plan 
+!start : true 
   <- .print("Implement Task 1"). 

/* 
 * Plan for reacting to a new belief ready_to_explore. 
 * The miner reacts by deciding to explore the route to a random position in the environment.
 * Triggering event: Addition of belief ready_to_explore
 * Context (before Task 1): true (the plan is always applicable)
 * Context (after Task 1): the agent has a belief about the size of the environment 
 * Body: the miner computes a random position (X,Y) and creates the goal to explore the route to it 
*/
@ready_to_explore_plan_1
/* Template
 +ready_to_explore : true 
   <-  
      jia.random(X,20) ; // action that unifies X with a random number in [0, 20]
      jia.random(Y,20) ; // action that unifies Y with a random number in [0, 20]
      .print("I will create the goal to explore (",X,",", Y,")");
      !explore(X,Y) . // creates goal explore(X,Y)
*/
+ready_to_explore : env_size(W,H)
   <-  
      jia.random(X,W-1) ; // action that unifies X with a random number in [0, W-1]
      jia.random(Y,H-1) ; // action that unifies Y with a random number in [0, H-1]
      .print("I will create the goal to explore (",X,",", Y,")");
      !explore(X,Y) . // creates goal explore(X,Y)

/* 
 * Plan for reacting to a new belief ready_to_explore
 * The miner reacts by waiting and becoming again ready to explore.
 * Triggering event: Addition of belief ready_to_explore
 * Context : true (the plan is always applicable)
 * Body: waits and removes the old belief ready_to_explore and adds a new belief ready_to_explore
*/
@ready_to_explore_plan_2
+ready_to_explore  : true
   <- .wait(100); // waits 100ms
      -+ready_to_explore. // removes the old belief ready_to_explore and adds a new belief ready_to_explore

/* 
 * Plan for reacting to a new belief near(X,Y)
 * The miner reacts by becoming again ready to explore
 * Triggering event: Addition of belief near(X,Y)
 * Context : ready_to_explore
 * Body: removes the old belief ready_to_explore and adds a new belief ready_to_explore
*/
@near_plan
+near(X,Y) : ready_to_explore 
   <- -+ready_to_explore. // removes the old belief ready_to_explore and adds a new belief ready_to_explore

/* 
 * Plan for achieving the goal !move_to(X,Y)
 * Triggering event: creation of goal !move_to(X,Y)
 * Context: the miner is already in position (X,Y)
 */
 @move_to_plan_1
+!move_to(X,Y) : current_position(X,Y)
   <- .print("I've reached ",X,"x",Y).

/* 
 * Plan for achieving the goal !move_to(X,Y)
 * Triggering event: creation of goal !move_to(X,Y)
 * Context: the miner is not in position (X,Y)
 */
@move_to_plan_2
+!move_to(X,Y) : not current_position(X,Y)
   <- 
      !next_step(X,Y); // creates a goal to take one more step towards (X,Y)
      !move_to(X,Y). // creates a goal to move to (X,Y)


// SOLUTION TASK 3
/*
@gold_plan[atomic]           // atomic: so as not to handle another event until handle gold is initialised
+gold(X,Y)
  :  not carrying_gold & ready_to_explore
  <- .print("Gold perceived: ",gold(X,Y)).
*/

// SOLUTION TASK 4 (1/2)
@gold_plan[atomic]           // atomic: so as not to handle another event until handle gold is initialised
+gold(X,Y) 
   : not carrying_gold & ready_to_explore
   <- -ready_to_explore;
     .print("Gold perceived: ",gold(X,Y));
     !init_handle(gold(X,Y)).


/* 
 * Plan for achieving the goal !init_handle(Gold), i.e. !init_handle(gold(X,Y))
 * The agent strives to achieve the goal by 1) removing any goals it currently has 
 * for moving to any position that is irrelevant to the position of the gold, and 
 * 2) creating the goal to handle the Gold. 
 * Triggering event: creation of goal !init_handle(Gold)
 * Context: the miner has a goal to move to a position 
 */
@init_handle_plan_1[atomic]
+!init_handle(Gold)
  :  .desire(go_near(_,_)) // the miner has a goal to go near to any position
  <- .print("Dropping near(_,_) desires and intentions to handle ",Gold);
     .drop_desire(go_near(_,_)); // action that removes the goal of going near to any position
     !!handle(Gold).

/* 
 * Plan for achieving the goal !init_handle(Gold), i.e. !init_handle(gold(X,Y))
 * The agent strives to achieve the goal creating the goal to handle the Gold. 
 * Triggering event: creation of goal !init_handle(Gold)
 * Context: true (the plan is always applicable)
 */   
@init_handle_plan_2[atomic]
+!init_handle(Gold)
  :  true
  <- !!handle(Gold). // creates the goal !handle(Gold), i.e. !handle(gold(X,Y))

/* 
 * Plan for achieving the goal !handle(gold(X,Y))
 * The agent strives to achieve the goal by 1) movin 
 * Triggering event: creation of goal !init_handle(Gold)
 * Context: true (the plan is always applicable)
 */
+!handle(gold(X,Y)) 
  :  not ready_to_explore & mine_base(BaseX,BaseY)
  <- .print("Handling ",gold(X,Y)," now.");

     !move_to(X,Y);
     pick;

     //
     !confirm_pick;

     !move_to(BaseX,BaseY);

     //
     !confirm_drop; //_location
     drop;
     .print("Finish handling ",gold(X,Y));
     //
     !!choose_gold.


// if ensure(pick/drop) failed, pursue another gold
-!handle(G) : G
  <- .print("failed to catch gold ",G);
     .abolish(G); // ignore source
     !!choose_gold.

-!handle(G) : true
  <- .print("failed to handle ",G,", it isn't in the BB anyway");
     !!choose_gold.

/* The next plans deal with picking up and dropping gold. */

+!confirm_pick : current_position(X,Y) & gold(X,Y)
  <- ?carrying_gold;
     .abolish(gold(X,Y));
     .print("Successfully picked gold at (",X,",", Y,")").

+!confirm_drop : current_position(X,Y) // make this an operation that returns a boolean
   <- 
   base_at(X,Y,State);
   !confirm_drop(State).

+!confirm_drop(State) : State // make this an operation that returns a boolean
   <- 
   .print("Successfully dropped gold").

+!confirm_drop(State) : mine_base(BaseX, BaseY) <- 
   -mine_base(_,_);
   .print("Dropping gold failed. Retrying to drop gold.");
   .wait(2000);
   !move_to(BaseX,BaseY);
   !confirm_drop.


/* The next plans encode how the agent can choose the next gold piece
 * to pursue (the closest one to its current position) or,
 * if there is no known gold location, makes the agent believe it is ready_to_explore.
 */
+!choose_gold
  :  not gold(_,_)
  <- -+ready_to_explore.

// Finished one gold, but others left
// find the closest gold among the known options,
// Keep it , describe the feature on README
+!choose_gold
  :  gold(_,_)
  <- .findall(gold(X,Y),gold(X,Y),LG);
     !calc_gold_distance(LG,LD);
     .length(LD,LLD); LLD > 0;
     .print("Gold distances: ",LD,LLD);
     .min(LD,d(_,NewG));
     .print("Next gold is ",NewG);
     !!handle(NewG).
-!choose_gold <- -+ready_to_explore.

+!calc_gold_distance([],[]).
+!calc_gold_distance([gold(GX,GY)|R],[d(D,gold(GX,GY))|RD])
  :  current_position(IX,IY)
  <- jia.dist(IX,IY,GX,GY,D);
     !calc_gold_distance(R,RD).
+!calc_gold_distance([_|R],RD)
  <- !calc_gold_distance(R,RD).

/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }

/* Import behavior of agents that explore the mine environment */
{ include("inc/exploration.asl") }