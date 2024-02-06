/* Initial beliefs and rules */
random_dir(DirList,RandomNumber,Dir) :- (RandomNumber <= 0.25 & .nth(0,DirList,Dir)) | (RandomNumber <= 0.5 & .nth(1,DirList,Dir)) | (RandomNumber <= 0.75 & .nth(2,DirList,Dir)) | (.nth(3,DirList,Dir)).

agentMode(Explore).

current_cell_occupied(false, 0, 0, ELEMENT).
stepsnum(20).   //------------------------
distance(e,20).
currloc_agent(0,0).
new_direction(s).

dispenserN :- thing(0,1,dispenser,_).
dispenserS :- thing(0,-1,dispenser,_).
dispenserE :- thing(1,0,dispenser,_).
dispenserW :- thing(-1,0,dispenser,_).

//dispensorFound(X,Y) : thing(X,Y, dispensor,_).
//dispenserfound(X,Y).
//goalfound(X,Y).
//blockattached(X,Y).
//atGoal(0,0).

/* Initial goals */

!start.


//!findDispensor.

/* Plans */

+!start : true <- 
	.print("hello massim world.").

//MOVES TOWARDS GOAL

// +step(X) : goal(XG,YG) & not goal(0,0)<-
//     -goalfound(XG,YG);
// 	+goalfound(XG,YG);
//     if(XG < 0){
//         move(w);
//     };
//     if(YG < 0){
//         move(n);
//     };
//     if(XG > 0){
//         move(e);
//     };
//     if(YG > 0){
//         move(n);
//     };.

// // +step(X) : goal(0,0) & goal(0,-1) <-
// //     move(s).
// // +step(X) : goal(0,0) & goal(1,0) <-
// //     move(e).
// // +step(X) : goal(0,0) & goal(0,-1) <-
// //     move(w).

// //IF AT GOAL SKIP STEP -- PLACEHOLDER
// +step(X) : goal(0,0) <-
//     skip.

+step(X) : blockattached(BX,BY,_) & not goal(GX,GY) <-
    !move_random.

// +step(X) : goal(X,Y) <-
//     +goalfound(X,Y).


// +step(X) : thing(DY,DY,dispenser,_) & goal(GX,GY) <-
//     -agentMode(Explore);
//     +agentMode(Task).

//+step(X) : agentMode(Explore) <-

//START OF WORKING CODE ---------------------

+step(X) : attached(BX,BY) & goal(0,0) & task(TASK,_,_,[req(BX,BY,B)]) <-  
    submit(TASK).

+step(X) : attached(BX,BY) & goal(0,0) <-
    if(BX == 1){
       rotate(cw);
   };
   if(BY == -1){
       rotate(ccw);
   };
   if(BX == -1){
       rotate(ccw);
   };.


//ATTEMPTING TO  MOVE WHEN BLOCK ATTACHED
+step(X) : attached(BX,BY)  & goal(XG,YG) & not goal(0,0)<-
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

+step(X) : attached(_,_) & not goal(_,_) <-
    move(w).

//ATTACH TO BLOCK WHEN AT DISPENSER
+step(X) : thing(0,1,block,B) <-
attach(s);
+blockattached(0,1,B).
+step(X) : thing(0,-1,block,B)<-
attach(n);
+blockattached(0,-1,B).
+step(X) : thing(1,0,block,B)<-
attach(e);
+blockattached(1,0,B).
+step(X) : thing(-1,0,block,B)<-
attach(w);
+blockattached(-1,0,B).

//REQUEST BLOCK WHEN AGENT IS AT DISPENSER
+step(X) : thing(0,1,dispenser,_) <-
 request(s).
+step(X) : thing(0,-1,dispenser,_) <-
 request(n).
+step(X) : thing(1,0,dispenser,_) <-
 request(e).
+step(X) : thing(-1,0,dispenser,_) <-
 request(w).


//MOVE TO DISPENSER
+step(X) : thing(TX,TY,dispenser,D) & not dispenserE & not dispenserN & not dispenserS & not dispenserW <- 
	.print("Determining my action");
    -dispenserfound(TX,TY,D);
	+dispenserfound(TX,TY,D);
    if(TX < 0){
        move(w);
    };
    if(TX > 0){
        move(e);
    };
    if(TY > 0){
        move(n);
    };
    if(TY < 0){
        move(n);
    };
	!agent_movment;
    !position_update(Dir).

+step(X) : dispenserE | dispenserN | dispenserS |  dispenserW <-
  skip.

+step(X) : not thing(TX,TY,dispenser,_) <-
    //!move_random.
    !agent_movment;
    !position_update(Dir).

+step(X) : not goal(GX,GY) <-
    //!move_random.
    !agent_movment;
    !position_update(Dir).

// +step(X) : true <-
//     !agent_movment;
//     !position_update(Dir);
// 	.print("Received step percept.").



+!move_random : .random(RandomNumber) & random_dir([n,s,e,w],RandomNumber,Dir) <-
    move(Dir).
 
+!agent_movment : distance(Dir,Dislength) & new_direction(Dir2) & current_cell_occupied(false, ObjX, ObjY, ELE) & stepsnum(PATH) <-
    .print("Starting Agent Movment");
 
    if (Dislength == 0) {
 
        .print("hbwbbfek");
 
        if (Dir == n){
            -+distance(w, PATH); //update
            -+new_direction(s); //update
        }
        elif (Dir == w){
            -+distance(s, PATH);
            -+new_direction(e);
        }
        elif (Dir == s){
            -+distance(e, PATH);
            -+new_direction(n);
        }
        elif (Dir == e){
            -+distance(n, PATH);
            -+new_direction(w);
        }
 
       move(Dir2);
       move(Dir2);
       -+distance(Dir2, PATH-1);
    }
    else{
        //move(Dir2);
        move(Dir);
        -+distance(Dir, Dislength-1);
    }.
 
 
+!agent_movment : current_cell_occupied(false, ObjX, ObjY, ELE) <-
    .print("stop agent mov and focus on req blocks or submitting block in the goal ");
    skip.
 
   
 
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
