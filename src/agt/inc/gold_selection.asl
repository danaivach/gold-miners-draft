/* The next plans encode how the agent can choose the next gold piec e
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