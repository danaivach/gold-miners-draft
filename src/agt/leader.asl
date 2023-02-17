// leader agent

{ include("$jacamoJar/templates/common-cartago.asl") }

/*
 * By Joao Leite
 * Based on implementation developed by Rafael Bordini, Jomi Hubner and Maicon Zatelli
 */

/* Initial beliefs */
depot(0,0). // the miner initially believes that the base of the mine is in position (0,0)

! start.

@start_plan
+!start : true 
   <- !work_on_base.

@work_on_base_plan_1
+!work_on_base : map_size(W,H) 
   <- .wait(10000);
      jia.random(X,W-1) ; // action that unifies X with a random number in [0, W-1]
      jia.random(Y,H-1) ; // action that unifies Y with a random number in [0, H-1]
      move_base(X,Y); // action that moves the base to position (X,Y)
      -+depot(X,Y); // removes the old belief mine_base(_,_) and adds a new belief mine_base(X,Y) 
      .send(miner, tell, depot(X,Y));
      !work_on_base.

@work_on_base_plan_2
+!work_on_base  : true
   <- .wait(100); // waits 100ms
      !work_on_base. // creates the goal work_on_base