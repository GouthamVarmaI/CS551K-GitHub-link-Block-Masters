/* Initial beliefs and rules */
random_dir(DirList,RandomNumber,Dir) :- (RandomNumber <= 0.25 & .nth(0,DirList,Dir)) | (RandomNumber <= 0.5 & .nth(1,DirList,Dir)) | (RandomNumber <= 0.75 & .nth(2,DirList,Dir)) | (.nth(3,DirList,Dir)).



dispenserN :- thing(0,1,dispenser,_).
dispenserS :- thing(0,-1,dispenser,_).
dispenserE :- thing(1,0,dispenser,_).
dispenserW :- thing(-1,0,dispenser,_).

//dispensorFound(X,Y) : thing(X,Y, dispensor,_).
//dispenserfound(X,Y).
goalfound(X,Y).
blockattached(X,Y).
atGoal(0,0).

/* Initial goals */

!start.


//!findDispensor.

/* Plans */

+!start : true <- 
	.print("hello massim world.").

// +step(X) : goal(XG,YG) & not goal(0,0)<-
//     -goalfound(XG,YG);
// 	+goalfound(XG,YG);
//     if(XG < 0){
//         move(w);
//     };
//     if(XG > 0){
//         move(e);
//     };
//     if(YG > 0){
//         move(n);
//     };
//     if(YG < 0){
//         move(n);
//     };.

// +step(X) : goal(0,0) <-
//     skip.

+step(X) : blockattached(BX,BY)  & goal(XG,YG) <-
    if(XG < 0){
        move(w);
    };
    if(XG > 0){
        move(e);
    };
    if(YG > 0){
        move(n);
    };
    if(YG < 0){
        move(n);
    };.
	
+step(X) : blockattached(BX,BY) <-
    move(n).

+step(X) : thing(0,1,dispenser,_) <-
 request(s).
+step(X) : thing(0,-1,dispenser,_) <-
 request(n).
+step(X) : thing(1,0,dispenser,_) <-
 request(e).
+step(X) : thing(-1,0,dispenser,_) <-
 request(w).

+step(X) : thing(0,1,block,_) & not blockattached(0,1) <-
 attach(s);
 +blockattached(0,1).
+step(X) : thing(0,-1,block,_) & not blockattached(0,-1)<-
 attach(n);
 +blockattached(0,-1).
+step(X) : thing(1,0,block,_) & not blockattached(1,0)<-
 attach(e);
 +blockattached(1,0).
+step(X) : thing(-1,0,block,_) & not blockattached(-1,0)<-
 attach(w);
 +blockattached(-1,0).

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
    };.
	//!move_random.

+step(X) : dispenserE | dispenserN | dispenserS |  dispenserW <-
    skip.

+step(X) : not thing(TX,TY,dispenser,_) <-
    !move_random.

+!move_random : .random(RandomNumber) & random_dir([n,s,e,w],RandomNumber,Dir)
<-	move(Dir).
