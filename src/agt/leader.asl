// leader agent

{ include("$jacamoJar/templates/common-cartago.asl") }

/*
 * By Joao Leite
 * Based on implementation developed by Rafael Bordini, Jomi Hubner and Maicon Zatelli
 */

! start.

+!start : true 
   <- !work_on_base.

+!work_on_base : true 
   <- .print("waiting");
      .wait(5000);
      move_base(20,20);
      !work_on_base.

