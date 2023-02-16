# Programming Your First Agent(s)!

Recently, rumours about the discovery of gold scattered around deep Carpathian woods made their way into the public. Consequently, hordes of gold miners are pouring into the area in the hope to collect as much of gold nuggets as possible. In this introductory tutorial, your task is to program a team of miner agents that will collect the gold and deliver it to a depot for safe storage.

The tutorial already includes most of the code required by your team of miners. It only leaves out a few parts — just enough to give you a guided tour of some of the features of autonomous agents discussed during the lecture.

This tutorial is a simplified version of (...) developed by (...).

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

You can run the project directly in VS Code or from the command line with [Gradle 7.4](https://gradle.org/).

### How to run in VS Code

TODO: add instructions

### Command Line (MacOS/Linux)

For Tasks 1-4:
```shell
./gradlew task_1_4
```
For Task 5:
```shell
./gradlew task_6
```
For Task 6: 
```shell
./gradlew task_6
```

### Command Line (Windows)

For Tasks 1-4:
```shell
gradlew.bat task_1_4
```
For Task 5:
```shell
gradlew.bat task_5
```
For Task 6: 
```shell
gradlew.bat task_6
```

## Gold Miners Tutorial

Your team of miners is situated on a grid map that represents the Carpathian woods.
Each agent in your team of miners is implemented by the _agent program_ given in [miner.asl](src/agt/miner.asl). This program is written in [Jason/AgentSpeak](https://github.com/jason-lang/jason), a programming language for _Belief-Desire-Intention (BDI) agents_.

We will learn more about BDI agents in Week 5. For the purpose of this tutorial, it is sufficient to know that a BDI agent has:
- _beliefs_:  information the agent holds about the world; beliefs are not necessarily true, they may be out of date or inaccurate; the agent's beliefs are stored in its _belief base_;
- _desires_ or _goals_: states of affairs the agent wishes to bring to the world;
- _intentions_: desires that the agent is committed to achieve.

In [miner.asl](src/agt/miner.asl), lines 8-12 define the _initial beliefs and goals_ of a miner agent:
- `ready_to_explore`: the agent believes that it is ready to woods for gold;
- `!start`: the agent has an initial goal to start, which is similar to the `main` method of a Java program; goals are expressed similarly to beliefs except they are preceeded by an exclamation point (`!`).

A BDI agent achieves its goals by executing _plans_ programmed by a developer. A plan has the following form:

```
@<plan annotation>
<trigerring_event> : <application_context> <-
   <action_1>;
   <action_2>;
   <action_3>.
```

In this tutorial, we will only use plan annotations to refer to plans easily. Then:
- the _triggering event_ states which event can trigger the execution of the plan;
- the _application context_ states the context in which the plan is applicable; if the context is `true`, the plan is applicable in any context;
- the _plan body_ is a recipe for action; note that the plan body is preceded by the sign `<-`, each action is followed by a semicolon (`;`), and the plan ends with a dot (`.`).

In this tutorial, we will use the following types of triggering events:
- `+!<goal>`: signals the creation of a goal, ex. `+!start`;
- `-!<goal>`: signals the deletion of a goal, ex. when the execution of an action in the plan body has failed;
- `+<belief>`: this event signals the addition of a blief to the agent's belief base, ex. `+ready_to_explore`;
- `-<belief>`: signals the delition of a belief from the agent's belief base, ex. `-ready_to_explore`.

With this minimal information, you are now ready to program your first agent!

### Task 1 - Hello world

Your first task is to write a plan that prints "Hello world of miners!" when the miner agent starts.

To print a statement, you can use the following action — and note that this is a special action whose name starts with a dot (`.`):

```
.print("text to be printed")
```

<details>
<summary>Solution</summary>

```
// miner.asl

/* 
 * Plan for achieving the goal !start 
 * Triggering event: Creation of goal !start
 * Context: true (the plan is always applicable)
 * Body: prints "Hello world of miners!"
*/
@start_plan 
+!start : true <-
   .print("Hello world of miners!").
```

</details>

### Task 2 - Beliefs about the world

The miner agent acquires beliefs throughout its lifetime, and you can inspect its belief base by visiting http://localhost:3272/ while running the project:

<img src="doc/miner1-beliefs.png?raw=true" width="400">

The creation of the initial belief `ready_to_explore` will trigger the plan `@ready_to_explore_plan` on lines 32-37. This plan achieves the following:
- it computes a random position (X,Y) within the grid environment;
- it creates the goal `!explore(X,Y)` for exploring the route to (X,Y); the agent will look for gold while exploring this route.

Currently, the width and height of the map are hard coded into the plan (Width = 20, Height = 20). If the agent has a belief about the size of the map, you can avoid hard coding these values: you can instead use variables to retrieve the values from the agent's belief base.

In AgentSpeak, a variable starts with a capital letter, and we can use the application context of a plan to match variables against the agent's belief base. For example, given the belief base shown in the above image, we can write the following plan to print the agent's current position when the agent starts:

// TODO: check if this makes sense, if not perhaps add an example plan that actually works (I haven't run the project)

```
+!start : current_position(X,Y) <-
   .print(X, " ", Y).
```

If the agent has a belief `current_position(12, 17)` when the agent starts, then the above plan would print `12 17`.

Your second task is to update the `@ready_to_explore_plan` to avoid hard coding the size of the map.

<!--
- the context of the `@ready_to_explore_plan` so that the plan is only executed when the agent has a belief `env_size(X,Y)`. Now, the plan will be applicable only if the variables X, Y become bound to specific values based on a _ground_ belief (e.g. `env_size(100, 100)`) of the miner's belief base at run time.
 - update the body of the plan such that the random position is computed based on variables X, Y instead of the hard coded values 20, 20.
 -->

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

You can click on the cells of the Mining World GUI to add gold nuggets to the map. While exploring the map, the miner agent can perceive gold nuggets are located in adjacent positions (the perception radius is 1 grid). 

When an agent receives a percept from the environment, the percept is reflected in the agent's beliefs. While your miner agent is exploring the map, you can again inspect its beliefs as shown above to see the addition of new `gold` beliefs.

Your third task is to create a `@gold_perceived_plan` in [miner.asl](src/agt/miner.asl) to enable the agent to react when it perceives a new gold nugget. Note that you can use variables in triggering events as well, ex. the triggering event `+gold(X,Y)` will match X and Y to the coordinates of the cell in which the gold nugget was perceived.

The `@gold_perceived_plan` plan should only be applicable if the agent is ready to explore (i.e., has the belief `ready_to_explore`) and the agent is not already carrying gold (i.e., does not have the belief `carrying_gold`). To implement such conditions in the plan's application context:
- you can use _logical and_ (`&`) and _logical or_ (`|`) to specicy conjunctions or disjunctions of beliefs that need to hold
- you can use the `not` keywords to specify that a belief should not hold (e.g., `not sunny`)

// TODO: does the plan need to be atomic? if so, we can just give away the plan annotation with the atomic

<!--
- the plan is triggered by the addition of the belief `gold(X,Y)` to the belief base (triggering event: `+gold(X,Y)`);
- the plan is applicable when the agent believes that it is `ready_to_explore` and (`&`) it is `not carrying_gold` (context);
- the plan prints a message about the position (X,Y) of the discovery of gold (body).
-->

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
