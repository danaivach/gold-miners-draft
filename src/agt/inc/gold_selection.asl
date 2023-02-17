/* 
 * Plan for reacting to the creation of goal !choose_gold
 * The plan is required for choosing to handle a gold nugget that was perceived in the past
 * Triggering event: creation of goal !choose_gold
 * Context: the agent does not believe that any gold nugget is located at the map
 * Body: deletes the old belief ready_to_explore and adds a new belief ready_to_explore
 */
+!choose_gold : not gold(_,_) <- 
    -+ready_to_explore. // deletes the old belief ready_to_explore and adds a new belief ready_to_explore

/* 
 * Plan for reacting to the creation of goal !choose_gold
 * The plan is required for choosing to handle a gold nugget that was perceived in the past
 * Triggering event: creation of goal !choose_gold
 * Context: the agent believes that a gold nugget is located at the map
 * Body: deletes the old belief ready_to_explore and adds a new belief ready_to_explore
 */
+!choose_gold : gold(_,_) <- 
    .findall(gold(X,Y),gold(X,Y),LG); // action that unifies LG with the list of all beliefs gold(X,Y)
     !calc_gold_distance(LG,LD); // creates goal !calc_gold_distance(LG,LD)
     .length(LD,LLD); LLD > 0; // action that unifies LLD with the length of the list LD
     .print("Gold distances: ",LD,LLD); 
     .min(LD,d(_,NewG)); // action that unifies NewG with the belief gold(X,Y) where (X,Y) is at the smallest distance in LD 
     .print("Next gold is ",NewG);
     !!handle(NewG). // creates goal !handle(NewG)

/* 
 * Plan for reacting to the deletion of goal !choose_gold
 * The plan is required for handling the failure of goal !choose_gold
 * Triggering event: deletion of goal !choose_gold
 * Context: true (the plan is always applicable)
 * Body: deletes the old belief ready_to_explore and adds a new belief ready_to_explore
 */
-!choose_gold : true <- 
    -+ready_to_explore. // deletes the old belief ready_to_explore and adds a new belief ready_to_explore

/* 
 * Plan for reacting to the creation of goal !calc_gold_distance([],[])
 * The plan is required for creating an empty list when there are no beliefs about perceived gold nuggets
 * Triggering event: creation of goal +!calc_gold_distance([],[])
 * Context: true (the plan is always applicable)
 * Body: empty
 */
+!calc_gold_distance([],[]). 

/* 
 * Plan for reacting to the creation of goal !calc_gold_distance([gold(GX,GY)|R],[d(D,gold(GX,GY))|RD])
 * The plan is required for creating a list with the distances to perceived gold nuggets
 * Triggering event: creation of goal +!calc_gold_distance([],[])
 * Context: the agent believes it is located at (IX,IY)
 * Body: unifies [d(D,gold(GX,GY))|RD] with the list of distances between the agent and the perceived gold nuggets
 */
+!calc_gold_distance([gold(GX,GY)|R],[d(D,gold(GX,GY))|RD]) : current_position(IX,IY) <- 
    jia.dist(IX,IY,GX,GY,D); // action that unifies D with the distance between the agent and a gold nugget
    !calc_gold_distance(R,RD). // creates goal !calc_gold_distance(R,RD)

+!calc_gold_distance([_|R],RD) : true <- 
    !calc_gold_distance(R,RD). 
