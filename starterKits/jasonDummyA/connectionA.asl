/* Initial beliefs and rules */
random_dir(DirList,RandomNumber,Dir) :- (RandomNumber <= 0.25 & .nth(0,DirList,Dir)) | (RandomNumber <= 0.5 & .nth(1,DirList,Dir)) | (RandomNumber <= 0.75 & .nth(2,DirList,Dir)) | (.nth(3,DirList,Dir)).

current_cell_occupied(false, 0, 0, ELEMENT).
stepsnum(20).  
distance(e,1).
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

// FAILED ROTATE

+step(X) : lastActionResult(failed) & lastActionParams([P]) & lastAction(rotate) <-
    if(P == cw){
        rotate(ccw);
    };
    if(P == ccw){
        move(cw);
    };.

// FAILED PATH

+step(X) : lastActionResult(failed_path) & lastActionParams([P]) & lastAction(move) <-

    if(P == e){
        move(n);
    };
    if(P == s){
        move(w);
    };
    if(P == w){
        move(s);
    };
    if(P == n){
        move(e);
    };.

// FAILED FORBIDDEN

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


// +step(X) : attached(DX,DY) & not blockattached(BX,BY,_) <-
//     -attached(DX,DY);
//     skip.
    // if(DX==0 & DY==-1){
    //     detach(n);
    // }
    // if(DX==0 & DY==1){
    //     detach(s);
    // }
    // if(DX==-1 & DY==0){
    //     detach(w);
    // }
    // if(DX==1 & DY==0){
    //     detach(e);
    // };.


// ROTATE WHEN THERE IS OBSTACLE ABOVE THE ATTACHED BLOCK

+step(X) : blockattached(BX,BY,_) & obstacle(DX,DY,_) & lastAction(move) & lastActionParams(PX) <-.
    if(BX == -1 & BY == 0 & DX == -1 & DY == -1 & PX == n){
        rotate(ccw);
        move(n);
    };
    if(BX == 1 & BY == 0 & DX == 1 & DY == -1 & PX == n){
        rotate(cw);
        move(n);
    };.


// SUBMIT TASK

+step(X) : blockattached(0,1,B) & goal(0,0) & not task(TASK,_,_,[req(0,1,B)]) <-  
    skip.

+step(X) : blockattached(0,1,B) & goal(0,0) & task(TASK,_,_,[req(0,1,B)]) <-  
    submit(TASK);
    -blockattached(0,1,_).

// ROTATE WHEN AT THE GOAL

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


// MOVE WHEN BLOCK ATTACHED

+step(X) : blockattached(BX,BY,_)  & not goal(XG,YG) <-
    !move_random.


//ATTACH TO BLOCK WHEN AT DISPENSER

+step(X) : thing(0,1,block,B) & thing(0,1,dispenser,_) & not blockattached(BX,BY,_) & lastAction(request)<-
    attach(s);
    +blockattached(0,1,B).

+step(X) : thing(0,-1,block,B) & thing(0,-1,dispenser,_) & not blockattached(BX,BY,_) & lastAction(request) <-
    attach(n);
    +blockattached(0,-1,B).

+step(X) : thing(1,0,block,B) & thing(1,0,dispenser,_) & not blockattached(BX,BY,_) & lastAction(request)<-
    attach(e);
    +blockattached(1,0,B).

+step(X) : thing(-1,0,block,B) & thing(-1,0,dispenser,_) & not blockattached(BX,BY,_) & lastAction(request)<-
    attach(w);
    +blockattached(-1,0,B).


// REQUEST BLOCKS FROM DISPENSERS

+step(X) : thing(0,1,dispenser,_) & not blockattached(BX,BY,_) <-
    request(s).

+step(X) : thing(0,-1,dispenser,_) & not blockattached(BX,BY,_) <-
    request(n).

+step(X) : thing(1,0,dispenser,_) & not blockattached(BX,BY,_) <-
    request(e).

+step(X) : thing(-1,0,dispenser,_) & not blockattached(BX,BY,_) <-
    request(w).



+step(X) : not thing(DX,DY,dispenser,_)<-
    !move_random.

+step(X) : not thing(DX,DY,dispenser,_) & not goal(XG,YG) <-
    !move_random.


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
        move(s);
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
        move(s);
    };.

//ATTEMPTING TO  MOVE WHEN BLOCK ATTACHED

+step(X) : blockattached(BX,BY,_)   & goal(XG,YG) & not goal(0,0)<-
    if(XG < 0){
        move(w);
    };
    if(YG < 0){
        move(s);
    };
    if(XG > 0){
        move(e);
    };
    if(YG > 0){
        move(n);
    };.

+step(X) : true <-
    !move_random.

+!move_random : .random(RandomNumber) & random_dir([n,s,e,w],RandomNumber,Dir)
<-	move(Dir).


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



// Moving north (P == "n") would decrement the Y coordinate, which is equivalent to moving up.
// Moving south (P == "s") would increment the Y coordinate, which is equivalent to moving down.
// Moving east (P == "e") would increment the X coordinate, which is equivalent to moving right.
// Moving west (P == "w") would decrement the X coordinate, which is equivalent to moving left.