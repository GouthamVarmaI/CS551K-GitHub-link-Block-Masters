/* Initial beliefs and rules */
random_dir(DirList,RandomNumber,Dir) :- (RandomNumber <= 0.25 & .nth(0,DirList,Dir)) | (RandomNumber <= 0.5 & .nth(1,DirList,Dir)) | (RandomNumber <= 0.75 & .nth(2,DirList,Dir)) | (.nth(3,DirList,Dir)).

current_cell_occupied(false, 0, 0, ELEMENT).
stepsnum(20).   //------------------------
distance(e,1).
//dispenserFound(false).
currloc_agent(0,0).
new_direction(s).

dispenserN :- thing(0,1,dispenser,_).
dispenserS :- thing(0,-1,dispenser,_).
dispenserE :- thing(1,0,dispenser,_).
dispenserW :- thing(-1,0,dispenser,_).

/* Initial goals */

!start.

/* Plans */

+!start : true <- 
	.print("hello massim world.").

// +step(X) : obstacle(1,0) & obstacle(-1,0) <-
//     move(n).

// +step(X) : obstacle(0,1) & obstacle(0,-1) <-
//     move(e).

+step(X) : blockattached(0,1) & obstacle(1,1) & obstacle(1,-1) <-
    rotate(cw).
+step(X) : blockattached(0,-1) & obstacle(1,1) & obstacle(1,-1) <-
    rotate(ccw).

+step(X) : blockattached(0,1) & obstacle(-1,-1) & obstacle(-1,1) <-
    rotate(ccw).
+step(X) : blockattached(0,-1) & obstacle(-1,-1) & obstacle(-1,1) <-
    rotate(cw).


// +step(X) : blockattached(0,1) & obstacle(-1,1) & obstacle(1,1) <-
//     move(n).
// +step(X) : blockattached(0,-1) & obstacle(-1,-1) & obstacle(1,-1) <-
//     move(s).

// +step(X) : blockattached(1,0) & obstacle(1,1) & obstacle(1,-1) <-
//     move(e).
// +step(X) : blockattached(-1,0) & obstacle(-1,1) & obstacle(-1,-1) <-
//     move(w).

// +step(X) : blockattached(0,1) & obstacle(-1,1) & obstacle(1,1) <-
//     move(n).
// +step(X) : blockattached(0,-1) & obstacle(-1,-1) & obstacle(1,-1) <-
//     move(s).


+step(X) : lastActionResult(failed) & lastActionParams([P]) & lastAction(rotate) <-

    if(P == cw){
       rotate(ccw);
   };
    if(P == ccw){
       move(cw);
   };.

+step(X) : lastActionResult(failed_path) & lastActionParams([P]) & lastAction(move) <-

    if(P == e){
       move(w);
   };
    if(P == s){
       move(n);
   };
   if(P == w){
       move(e);
   };
   if(P == n){
       move(s);
   };.

   +step(X) : lastActionResult(failed_forbidden) & lastActionParams([P]) & lastAction(move) <-


    if(P == e){
       move(w);
   };
    if(P == s){
       move(n);
   };
   if(P == w){
       move(e);
   };
   if(P == n){
       move(s);
   };.

// +step(X) : lastActionResult(failed_forbidden) &   // tocheck if the current failure case is due to a forbidden action
//     lastActionParams([P]) &               // Extract the parameters of the current action
//     currloc_agent(X,Y)  &   // heck if the current cell is not occupied
//     distance(Dir, dislength) <-            // get the distance from the agent to a certain direction                          
   
//     .print("Failed Forbiddne");                  
   
//     .member(F, P);                              // to check if the parameter F is a member of the action parameters
//     if(F==n){                                   // if the parameter indicates a move to the north direction
//         -+currloc_agent(X, Y+1);               // update the current location of the agent accordingly (move north)
//         -+distance(s, Path);                    
//     }
//     elif(F==w){                                
//         -+currloc_agent(X+1, Y);              
//         -+distance(e, Path);                  
//     }
//     elif(F==s){                                
//         -+currloc_agent(X, Y-1);              
//         -+distance(n, Path);                  
//     }
//     elif(F==e){                                
//         -+currloc_agent(X-1, Y);              
//         -+distance(w, Path);                  
//     }.

// +step(X) : lastActionResult(failed_path) &   // tocheck if the current failure case is due to a forbidden action
//     lastActionParams([P]) &               // Extract the parameters of the current action
//     currloc_agent(X,Y)  &   // heck if the current cell is not occupied
//     distance(Dir, dislength) <-            // get the distance from the agent to a certain direction                          
   
//     .print("Failed Path");                  
   
//     .member(F, P);                              // to check if the parameter F is a member of the action parameters
//     if(F==n){                                   // if the parameter indicates a move to the north direction
//         -+currloc_agent(X, Y+1);               // update the current location of the agent accordingly (move north)
//         -+distance(s, Path);                    
//     }
//     elif(F==w){                                
//         -+currloc_agent(X+1, Y);              
//         -+distance(e, Path);                  
//     }
//     elif(F==s){                                
//         -+currloc_agent(X, Y-1);              
//         -+distance(n, Path);                  
//     }
//     elif(F==e){                                
//         -+currloc_agent(X-1, Y);              
//         -+distance(w, Path);                  
//     }.

+step(X) : blockattached(0,1,B) & goal(0,0) & not task(TASK,_,_,[req(0,1,B)]) <-  
    skip.

+step(X) : blockattached(0,1,B) & goal(0,0) & task(TASK,_,_,[req(0,1,B)]) <-  
    -blockattached(0,1,B);
    submit(TASK).


+step(X) : blockattached(BX,BY,_) & goal(0,0) <-
    if(BX == 1){
        -blockattached(BX,BY,B);
        +blockattached(BX-1,BY+1,B);
       rotate(cw);
   };
   if(BY == -1){
        -blockattached(BX,BY,B);
        +blockattached(BX-1,BY+1,B);
       rotate(ccw);
   };
   if(BX == -1){
        -blockattached(BX,BY,B);
        +blockattached(BX+1,BY+1,B);
       rotate(ccw);
   };.

+step(X) : blockattached(BX,BY,_) & goal(0,1) <-
    move(s).

//ATTEMPTING TO  MOVE WHEN BLOCK ATTACHED
+step(X) : blockattached(BX,BY,_)  & goal(XG,YG) & not goal(0,0)<-
   if(XG < 0){
       move(w);
   };
    if(YG < 0){
       move(n);
   };
   if(XG > 0){
       move(e);
   };
   if(YG > 0){
       move(s);
   };.

+step(X) : blockattached(BX,BY,_)  & not goal(XG,YG) <-
    // !agent_movment;
    // !position_update(Dir).
    !move_random.

//ATTACH TO BLOCK WHEN AT DISPENSER
+step(X) : thing(0,1,block,B) & thing(0,1,dispenser,_) & not blockattached(BX,BY,_) & lastAction(request)<-
+blockattached(0,1,B);
attach(s).
+step(X) : thing(0,-1,block,B) & thing(0,-1,dispenser,_) & not blockattached(BX,BY,_) & lastAction(request) <-
+blockattached(0,-1,B);
attach(n).
+step(X) : thing(1,0,block,B) & thing(1,0,dispenser,_) & not blockattached(BX,BY,_) & lastAction(request)<-
+blockattached(1,0,B);
attach(e).
+step(X) : thing(-1,0,block,B) & thing(-1,0,dispenser,_) & not blockattached(BX,BY,_) & lastAction(request)<-
+blockattached(-1,0,B);
attach(w).

// REQUEST BLOACKS FROM DISPENSERS
+step(X) : thing(0,1,dispenser,_) & not blockattached(BX,BY,_) <-
 request(s).
+step(X) : thing(0,-1,dispenser,_) & not blockattached(BX,BY,_) <-
 request(n).
+step(X) : thing(1,0,dispenser,_) & not blockattached(BX,BY,_) <-
 request(e).
+step(X) : thing(-1,0,dispenser,_) & not blockattached(BX,BY,_) <-
 request(w).

+step(X) : not thing(DX,DY,dispenser,_)<-
    // !agent_movment;
    // !position_update(Dir).
    !move_random.

+step(X) : not thing(DX,DY,dispenser,_) & not goal(XG,YG) <-
    // !agent_movment;
    // !position_update(Dir).
    !move_random.

+step(X) : obstacle(0,-1) & lastActionParams([n])  <-
    move(e).
+step(X) : obstacle(0,1) & lastActionParams([s])<-
    move(e).
+step(X) : obstacle(1,0) & lastActionParams([e])<-
    move(n).
+step(X) : obstacle(-1,0) & lastActionParams([w])<-
    move(n).

// MOVING TOWARDS DISPENSER
+step(X) : thing(DX,DY,dispenser,_) & not dispenserE & not dispenserN & not dispenserS & not dispenserW<-
    .print("Determining my action");
    if(DX < 0){
        move(w);
    };
    if(DY < 0){
        move(n);
    };
    if(DX > 0){
        move(e);
    };
    if(DY > 0){
        move(n);
    };.

// MOVING TOWARDS GOAL
+step(X) : goal(XG,YG) & not goal(0,0)<-
    -goalfound(XG,YG);
	+goalfound(XG,YG);
    if(XG < 0){
        move(w);
    };
    if(YG < 0){
        move(n);
    };
    if(XG > 0){
        move(e);
    };
    if(YG > 0){
        move(n);
    };.

//ATTEMPTING TO  MOVE WHEN BLOCK ATTACHED
+step(X) : blockattached(BX,BY,_)   & goal(XG,YG) & not goal(0,0)<-
   if(XG < 0){
       move(w);
   };
    if(YG < 0){
       move(n);
   };
   if(XG > 0){
       move(e);
   };
   if(YG > 0){
       move(s);
   };.

+step(X) : true <-
    !move_random.

+!move_random : .random(RandomNumber) & random_dir([n,s,e,w],RandomNumber,Dir)
<-	move(Dir).

// +!agent_movment : current_cell_occupied(false, ObjX, ObjY, ELE) <-
//     .print("stop agent mov and focus on req blocks or submitting block in the goal ");
//     skip.
 
 
 
// Moving north (P == "n") would decrement the Y coordinate, which is equivalent to moving up.
// Moving south (P == "s") would increment the Y coordinate, which is equivalent to moving down.
// Moving east (P == "e") would increment the X coordinate, which is equivalent to moving right.
// Moving west (P == "w") would decrement the X coordinate, which is equivalent to moving left.
 
+!position_update(P): currloc_agent(X,Y) <-
    if(P==n){
        -+currloc_agent(X,Y-1);
    }
    elif(P==s){
        -+currloc_agent(X,Y+1);
    }
    elif(P==e){
        -+currloc_agent(X+1,Y);
    }
    elif(P==w){
        -+currloc_agent(X-1,Y);
    }.

    /*
 
 Functionality: The "move" action is responsible for relocating an agent in a particular direction within a given environment or grid.
 
Parameter: The action expects one parameter, which is the direction the agent intends to move. This direction can be one of four options: north (n), south (s), east (e), or west (w).
 
Failure Codes:
 
failed_parameter: This failure code indicates that the provided parameter for the "move" action is not a valid direction. In other words, if the direction specified is not one of {n, s, e, w}, the action cannot be performed.
failed_path: This failure code signifies that the agent cannot move to the target location because either the destination or the path to it is blocked by obstacles or other objects.
failed_forbidden: This failure code indicates that the agent cannot move to the specified direction because the new position would be outside the boundaries of the map or grid. It implies that the move would take the agent beyond the permissible area.
 
 
 
 
 
 
 move
Moves the agent in the specified direction.
 
No  Parameter   Meaning
0   direction   One of {n,s,e,w}, representing the direction the agent wants to move in.
Failure Code    Reason
failed_parameter    Parameter is not a direction.
failed_path Cannot move to the target location because the agent or one of its attached things are blocked.
failed_forbidden    New agent position would be out of map/grid bounds. */
 
 
 
//  a rule for handling the case when the previous move of the agentt failed
// +prev_move(move):
//     current_failed_case(failed_forbidden) &   // tocheck if the current failure case is due to a forbidden action
//     current_parameter_case(P) &               // Extract the parameters of the current action
//     currloc_agent(X,Y)  &                    
//     current_cell_occupied(false, ObjX, ObjY, ELE) &  // heck if the current cell is not occupied
//     distance(Dir, dislength) &                 // get the distance from the agent to a certain direction
//     stepsnum(Path) <-                          
   
//     .print("ahnzfdnviuzf");                  
   
//     .member(F, P);                              // to check if the parameter F is a member of the action parameters
//     if(F==n){                                   // if the parameter indicates a move to the north direction
//         -+currloc_agent(X, Y+1);               // update the current location of the agent accordingly (move north)
//         -+distance(e, Path);                    
//     }
//     elif(F==w){                                
//         -+currloc_agent(X+1, Y);              
//         -+distance(n, Path);                  
//     }
//     elif(F==s){                                
//         -+currloc_agent(X, Y-1);              
//         -+distance(w, Path);                  
//     }
//     elif(F==e){                                
//         -+currloc_agent(X-1, Y);              
//         -+distance(s, Path);                  
//     } .