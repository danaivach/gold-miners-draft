
+gsize(_,W,H) : true 
   <- +env_size(W,H) .

+pos(X,Y) : true 
   <- -+current_position(X,Y). 
      
+cell(X,Y,gold) <- +gold(X,Y).