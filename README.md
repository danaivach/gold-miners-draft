# Programming your first Agent - Gold Miners Tutorial 

## Table of Contents
-   [How to run the project](#how-to-run-the-project)
-   [Gold Miners Tutorial](#gold-miners-tutorial)
    -  [Task 1 - Hello World](#task-1---hello-world)
    -  [Task 2 - Beliefs about the world](#task-2---beliefs-about-the-world)
    -  [Task 3 - Reactive behavior](#task-3---reactive-behavior)
    -  [Task 4 - Proactive behavior](#task-4---proactive-behavior)
    -  [Task 5 - Social ability](#task-5---social-ability)
    -  [Task 6 - Towards Multi-Agent Systems](#task-6---towards-multi-agent-systems)
    -  Task 7?
-   [Submission]

## How to run the project
Run with [Gradle 7.4](https://gradle.org/): 
- MacOS and Linux: run the following commands
- Windows: replace `./gradlew` with `gradlew.bat`

For Tasks 1-4:
```shell
./gradlew task_a
```
For Task 5:
```shell
./gradlew task_b
```
For Task 6: 
```shell
./gradlew task_c
```

## Gold Miners Tutorial

### Task 1 - Hello world
In `miner.asl`, l. 8-12 define the _initial beliefs and goals_ of a miner agent. The miner is initialized as follows:
- `ready_to_explore`: the agent believes that it is ready to explore the mine for gold;
- `!start`: the agent has the goal to start.

Upon initialization, the miner reacts to the creation of initial beliefs and goals. For example, the miner stives to achieve the goal `!start` by executing the `start_plan` (l. 19-21). Update the body of the `start_plan` so that the miner prints "Hello world" upon initialization.

<details>
<summary>Solution</summary>

```
// miner.asl

/* 
 * Plan for achieving the goal !start 
 * Triggering event: Creation of goal !start
 * Context: true (the plan is always applicable)
 * Body: prints "Hello World"
*/
@start_plan 
+!start : true 
   <- .print("Hello World").
```

</details>

### Task 2 - Beliefs about the world
An agent can update, add, or remove beliefs of its belief base at run time, so that its behavior remains decoupled details about the world.

The miner agent reacts to the creation of the initial belief `ready_to_explore` by executing the `ready_to_explore_plan_1` (l.32-37). Based on the body of the plan, the miner behaves as follows:
- it computes a random position (X,Y) within the mine environment;
- it creates the goal `!explore(X,Y)` for exploring the route to (X,Y) while looking for gold.

Currently, the dimension of the mine environment (Width = 21, Height = 21) are hardcoded into the miner's plan. We can decouple the miner's plan from specific environment details with the use of _agent beliefs_ and _variables_. Visit http://localhost:3272/ to inspect which beliefs the agent acquires at run time:

<img src="media/miner1-beliefs.png?raw=true" width="400">

Check the syntax of the agent's belief about the environment size (`env_size`) to update:
- the context of `ready_to_explore_plan_1` so that the plan is only executed when the agent has a belief `env_size(X,Y)`. Now, the plan will be applicable only if the variables X, Y become bound to specific values based on a _ground_ belief (e.g. `env_size(100, 100)`) of the miner's belief base at run time.
- the body of the plan so that the random position is computed based on the variables X, Y instead of the hardcoded values 20, 20. 

<details>
<summary>Solution</summary>

```
// miner.asl

/* 
 * Plan for reacting to a new belief ready_to_explore. 
 * The miner reacts by deciding to explore the route to a random position in the environment.
 * Triggering event: Addition of belief ready_to_explore
 * Context: true (the plan is always applicable)
 * Body: the miner computes a random position (X,Y) and creates the goal to explore the route to it 
*/
@ready_to_explore_plan_1
+ready_to_explore : env_size(W,H)
   <-  
      jia.random(X,W-1) ; // action that unifies X with a random number in [0, W-1]
      jia.random(Y,H-1) ; // action that unifies Y with a random number in [0, H-1]
      .print("I will create the goal to explore (",X,",", Y,")");
      !explore(X,Y) . // creates goal explore(X,Y)
```

</details>

### Task 3 - Reactive behavior
An agent can react when a belief of its belief base is updated, added, or removed.
    
While exploring the mine environment, the miner can perceive gold located at its adjacent positions (perception scope radius: 1 grid). 

Click on the cells of the Mining World GUI to add gold for the miner to discover, and inspect the beliefs of the agent at http://localhost:3272/ to see the addition of the belief `gold` when the miner perceives any gold. 

Create a `gold_plan` in `miner.asl` to enable the agent to _react to the addition of a belief_ `gold(X,Y)` by behaving as follows:
- the plan is triggered by the addition of the belief `gold(X,Y)` to the belief base (triggering event: `+gold(X,Y)`);
- the plan is applicable when the agent believes that it is `ready_to_explore` and (`&`) it is `not carrying_gold` (context);
- the plan prints a message about the position (X,Y) of the discovery of gold (body).

<details>
<summary>Solution</summary>

```
// miner.asl

/* 
 * Plan for reacting to a new belief gold(X,Y). 
 * Triggering event: addition of belief gold(X,Y)
 * Context: the miner believes that it is ready to explore, and does not believe that it is carrying gold
*/
@gold_plan[atomic]          
+gold(X,Y)
  :  ready_to_explore & not carrying_gold
  <- .print("Gold perceived: ",gold(X,Y)).
```

</details>

### Task 4 - Proactive behavior 
An agent can strive to achieve a goal when a goal is created.
    
Even though the agent perceives gold in the environment, it cannot achieve to pick it up and drop it in the mine base.

Update `handle_gold_plan` so that it enables the miner to pursue the goal of a) picking the perceived gold, and b) dropping it in the base by behaving as as follows:
- the plan is triggered by the creation of the goal `!handle_gold(gold(X,Y))` (triggering event: `+!handle_gold(gold(X,Y))`)
- the plan is applicable when the agent believes that it is `not ready_to_explore` and that `mine_base(BaseX, BaseY)`
- the plan has a body that consists of the following:
  - the miner creates the goal of moving to the position of the gold (goal: `!moveTo`)
  - the miner picks the gold (action: `pick`)
  - the miner creates the goal of confirming that the gold has been picked (goal: `!confirm_pick`)
  - the miner creates the goal of moving to the position of the base (goal: `!moveTo`)
  - the miner creates the goal of confirming that the base is there (goal: `!confirm_base`)
  - the miner drops the gold at the base (action: `drop`)
  - the miner creates the goal of handling other gold pieces (goal: `!choose_gold`)
    
<details>
<summary>Solution</summary>

```
// miner.asl

/* 
 * Plan for achieving the goal !handle(gold(X,Y))
 * The agent strives to achieve the goal by a) picking the perceived gold, and b) dropping it in the base
 * Triggering event: creation of goal !handle(gold(X,Y))
 * Context: the miner believes that the mine base is in position (BaseX,BaseY) and it is not ready_to_explore
 */
+!handle(gold(X,Y)) 
  :  not ready_to_explore & mine_base(BaseX,BaseY)
  <- .print("Handling ",gold(X,Y)," now.");
     !move_to(X,Y); // creates the goal of moving to the position of the gold
     pick; // action that picks the gold
     !confirm_pick; // creates the goal of confirming that the gold has been picked
     !move_to(BaseX,BaseY); // creates the goal of moving to the position of the base
     !confirm_base; // creates the goal of confirming that the base is there
     drop; // action that drops the gold at the base
     .print("Finish handling ",gold(X,Y));
     !!choose_gold. // creates the goal of handling other gold pieces
```

</details>

### Task 5 - Social Ability

Agents can communicate with each other in order to share knowledge (i.e. beliefs) about the world.
    
The environment now becomes more dynamic, since a `leader` agent is responsible for frequently moving the base of the mine (ADD WHY). As a result, the miner may fail to drop the gold at the base if the position of the base does not match the miner's initial belief (`mine_base(0,0)). 

Update the `work_on_base_plan_1` in `leader.asl` so that the leader [tells](https://jason.sourceforge.net/api/jason/stdlib/send.html) the miner about the new position of the base every time it moves the base.

<details>
<summary>Solution</summary>

```
// leader.asl
@work_on_base_plan_1
+!work_on_base : env_size(W,H) 
   <- .wait(10000);
      jia.random(X,W-1) ; // action that unifies X with a random number in [0, W-1]
      jia.random(Y,H-1) ; // action that unifies Y with a random number in [0, H-1]
      move_base(X,Y); // action that moves the base to position (X,Y)
      -+mine_base(X,Y); // removes the old belief mine_base(_,_) and adds a new belief mine_base(X,Y) 
      .send(miner, tell, mine_base(X,Y)); // sends a message to miner telling that the mine_base is in position (X,Y)
      !work_on_base. // creates the goal !work_on_base
```

</details>

### Task 6 - Towards Multi-Agent Systems
    
More than one agents can be situated in the same environment

Now 4 miners and 1 leader are situated in the mine environment. However, only the first miner receives messages from the leader, while the rest of the miners do not get informed about the position of the base. 

Update the `work_on_base_plan_1` in `leader.asl` so that the leader now [broadcasts](https://jason.sourceforge.net/api/jason/stdlib/broadcast.html) the position of the mine base to all the agents instead of only telling `miner`.

<details>
<summary>Solution</summary>

```
// leader.asl
@work_on_base_plan_1
+!work_on_base : env_size(W,H) 
   <- .wait(10000);
      jia.random(X,W-1) ; // action that unifies X with a random number in [0, W-1]
      jia.random(Y,H-1) ; // action that unifies Y with a random number in [0, H-1]
      move_base(X,Y); // action that moves the base to position (X,Y)
      -+mine_base(X,Y); // removes the old belief mine_base(_,_) and adds a new belief mine_base(X,Y) 
      .boradcast(tell, mine_base(X,Y)); // broadcasts a message telling that the mine_base is in position (X,Y)
      !work_on_base. // creates the goal !work_on_base
```

</details>
