# Programming Your First Agent(s)!

Recently, rumours about the discovery of gold scattered around deep Carpathian woods made their way into the public. Consequently, hordes of gold miners are pouring into the area in the hope to collect as much of gold nuggets as possible. In this introductory tutorial, your task is to program a team of miner agents that will collect the gold and deliver it to a depot for safe storage.

The tutorial already includes most of the code required by your team of miners. It only leaves out a few parts — just enough to give you a guided tour of some of the features of autonomous agents discussed during the lecture.

This tutorial is a simplified version of the winning implementation developed in the context of the 2nd [Multi-Agent Programming (CLIMA VII) Contest](https://multiagentcontest.org/). No submission is required, but feel free to [send me](mailto:danai.vachtsevanou@unisg.ch) your questions.

Recommended editor: [Visual Studio Code](https://code.visualstudio.com/)

Useful VSCode extensions: 
- For AgentSpeak syntax highlighting: [code-mas2j](https://marketplace.visualstudio.com/items?itemName=tkampik.code-mas2j)
- For JaCaMo syntax highlighting: [code-jcm](https://marketplace.visualstudio.com/items?itemName=u473t8.code-jcm)
- For Gradle view: [Gradle for Java](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-gradle)

Optional reading material: [<u>Chapter 4.1</u> of Boissier, O., Bordini, R. H., Hubner, J., & Ricci, A. (2020). Multi-agent oriented programming: programming multi-agent systems using JaCaMo. Mit Press.](https://mitpress.ublish.com/book/multi-agent-oriented-programming-programming-multi-agent-systems-using-jacamo)

## Table of Contents
-   [Project structure](#project-structure)
-   [How to run the project](#how-to-run-the-project)
-   [Gold Miners Tutorial](#gold-miners-tutorial)
    -  [Task 1 - Hello World](#task-1---hello-world)
    -  [Task 2 - Beliefs about the world](#task-2---beliefs-about-the-world)
    -  [Task 3 - Reactive behavior](#task-3---reactive-behavior)
    -  [Task 4 - Proactive behavior](#task-4---proactive-behavior)
    -  [Task 5 - Social ability](#task-5---social-ability)
    -  [Task 6 - Towards Multi-Agent Systems](#task-6---towards-multi-agent-systems)

## Project structure
```
├── src
│   ├── agt
│   │   ├── miner.asl // agent program of miner agents
│   │   ├── leader.asl // agent program of the leader agent
│   │   └── inc
│   │       └── exploration.asl // program that supports miner agents in exploring the grid environment
│   └── env
├── mas_1_4.jcm // the configuration file of the JaCaMo application for tasks 1-4
├── mas_5.jcm // the configuration file of the JaCaMo application for task 5
└── mas_6.jcm // the configuration file of the JaCaMo application for task 6
```
 
## How to run the project

You can run the project directly in VS Code or from the command line with [Gradle 7.4](https://gradle.org/). The available Gradle tasks are:

- For Tasks 1-4: `task_1_4`
- For Task 5: `task5`
- For Task 6: `task6`

### How to run in VS Code

In VSCode, click the Gradle Side Bar elephant, and navigate through the Gradle Tasks to run one of the `jacamo` tasks:

<img src="doc/vscode-gradle-view-annotated.png?raw=true" width="200">

### Command Line (MacOS/Linux/Windows)

- MacOS and Linux: Use the command `./gradlew` to run one of the Gradle Tasks, e.g.:
```shell
./gradlew task_1_4
```
- Windows: replace Use the command `gradlew.bat` to run one of the Gradle Tasks, e.g.:
```shell
gradlew.bat task_1_4
```

## Gold Miners Tutorial

Your team of miners is situated on a grid map that represents the Carpathian woods. Each agent in your team of miners is implemented by the _agent program_ given in [miner.asl](src/agt/miner.asl). This program is written in [Jason/AgentSpeak](https://github.com/jason-lang/jason), a programming language for _Belief-Desire-Intention (BDI) agents_.

We will learn more about BDI agents in Week 5. For the purpose of this tutorial, it is sufficient to know that a BDI agent has:
- _beliefs_:  information the agent holds about the world; beliefs are not necessarily true, they may be out of date or inaccurate; the agent's beliefs are stored in its _belief base_;
- _desires_ or _goals_: states of affairs the agent wishes to bring to the world;
- _intentions_: desires that the agent is committed to achieve.

In [miner.asl](src/agt/miner.asl), lines 8-13 define the _initial beliefs and goals_ of a miner agent:
- `ready_to_explore`: the agent believes that it is ready to explore the woods for gold;
- `depot(0,0)`: the agent believes that the depot is located at (0,0);
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
- `+<belief>`: signals the addition of a belief to the agent's belief base, ex. `+ready_to_explore`;
- `-<belief>`: signals the deletion of a belief from the agent's belief base, ex. `-ready_to_explore`.

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
 * Triggering event: creation of goal !start
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

<img src="doc/miner-beliefs.png?raw=true" width="400">

The creation of the initial belief `ready_to_explore` will trigger the plan `@ready_to_explore_plan` on lines 32-37. This plan achieves the following:
- it computes a random position (X,Y) within the grid environment;
- it creates the goal `!explore(X,Y)` for exploring the route to (X,Y); the agent will look for gold while exploring this route.

Currently, the width and height of the map are hard coded into the plan (Width = 20, Height = 20). If the agent has a belief about the size of the map, you can avoid hard coding these values: you can instead use variables to retrieve the values from the agent's belief base.

In AgentSpeak, a variable starts with a capital letter, and we can use the application context of a plan to match variables against the agent's belief base. For example, given the belief base shown in the above image, we can write the following plan to print the agent's current position when the agent starts:

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
 * Plan for reacting to the addition of the belief ready_to_explore to the agent's belief base
 * Triggering event: addition of belief ready_to_explore
 * Context (before Task 2): true (the plan is always applicable)
 * Context (after Task 2): the agent has a belief about the size of the map
 * Body: the miner computes a random location (X,Y) and creates the goal to explore the route to it 
*/
@ready_to_explore_plan
+ready_to_explore : map_size(W,H) <-  
   jia.random(X,W) ; // action that unifies X with a random number in [0, W]
   jia.random(Y,H) ; // action that unifies Y with a random number in [0, H]
   .print("I will create the goal to explore (",X,",", Y,")");
   !explore(X,Y) . // creates goal explore(X,Y)
```

</details>

### Task 3 - Reactive behavior

You can click on the cells of the Mining World GUI to add gold nuggets to the map. While exploring the map, the miner agent can perceive gold nuggets are located in adjacent positions (the perception radius is 1 grid). 

When an agent receives a percept from the environment, the percept is reflected in the agent's beliefs. While your miner agent is exploring the map, you can again inspect its beliefs as shown above to see the addition of new `gold` beliefs.

Your third task is to create a `@gold_perceived_plan` in [miner.asl](src/agt/miner.asl) to enable the agent to react when it perceives a new gold nugget. Note that you can use variables in triggering events as well, ex. the triggering event `+gold(X,Y)` will match X and Y to the coordinates of the cell in which the gold nugget was perceived.

The `@gold_perceived_plan` should only be applicable if the agent is ready to explore (i.e., has the belief `ready_to_explore`) and the agent is not already carrying gold (i.e., does not have the belief `carrying_gold`). To implement such conditions in the plan's application context:
- you can use _logical and_ (`&`) and _logical or_ (`|`) to specicy conjunctions or disjunctions of beliefs that need to hold
- you can use the `not` keywords to specify that a belief should not hold (e.g., `not sunny`)

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
    
Currently, the miner agent can perceive gold nuggets but it cannot handle them.

Your fourth task is to complete the `@handle_gold_plan` in [miner.asl](src/agt/miner.asl) to enable the agent to achieve its goal of collecting a perceived gold nugget and delivering it to the depot. The triggering event and the context of the plan are already provided, and there are two available actions for completing the plan body:
    
- `pick` : collects a gold nugget. The action succeeds if the miner agent is in the position of a gold nugget, e.g. the agent in position (X,Y) collects the gold nugget that is perceived in position (X,Y)
- `drop` : drops a gold nugget in the depot. The action succeeds if the miner is carrying gold, and is in the position of the depot
    
For ensuring the success of the action execution, and therefore the achievement of the goal to handle the gold, the plan body should enable the agent not only to pick and drop, but also to move to the position of a gold nugget or of the depot, confirm that a gold nugget has been picked successfully, and confirm that the agent is in the position of the depot. 

In AgentSpeak, complex plans might require the agent to achieve (other) specific goals amid the actions to be taken. For example, we can write the following plan for creating the goal of moving to a specific position while the agent strives to achieve the goal of handling a gold nugget. This generates the triggering event `+!move_to(X,Y)`, and the agent strives to achieve the _sub-goal_ of moving by executing the `@move_to_plan` that is provided in lines (TBA). 

```
@handle_gold_plan
+!handle(gold(X,Y)) : true <-
   !move_to(X,Y);
   .print("I moved to ",gold(X,Y)).                          
```
You can enrich the body of the `@handle_gold_plan` by creating goals that will trigger the execution of the following provided plans:
- `@move_to_plan` (lines TBA): enables the agent to achieve moving to a position (X,Y)
- `@confirm_pick_plan` : enables the agent to achieve confirming that it is in the position of a gold nugget and it is carrying the gold nugget
- `@confirm_depot_plan` : enables the agent to achieve confirming that it is the position of a depot
                              
In [miner.asl](src/agt/miner.asl), the goal of handling gold is created in the body of the `@init_handle_plan` (lines TBA) — a plan dedicated to the initialization of the gold handling process. Update your `@gold_perceived_plan` from Task 3, so that the goal of initializing the handling process is created as explained above. This will eventually generate the triggering event `+!handle(gold(X,Y))`, and the agent will strive to achieve its goal by executing your updated `@handle_gold_plan`.
                              
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
   : not carrying_gold & ready_to_explore
   <- -ready_to_explore;
     .print("Gold perceived: ",gold(X,Y));
     !init_handle(gold(X,Y)). // creates the goal !init_handle(gold(X,Y))

/* 
 * Plan for achieving the goal !handle(gold(X,Y))
 * The agent strives to achieve the goal by a) picking the perceived gold, and b) dropping it in the base
 * Triggering event: creation of goal !handle(gold(X,Y))
 * Context: the miner believes that the mine base is in position (BaseX,BaseY) and it is not ready_to_explore
 */
+!handle(gold(X,Y)) 
  :  not ready_to_explore & depot(DepotX,DepotY) // the agent does not believe it is ready to explore, and believes that the depot is located at (DepotX,DepotY) 
  <- .print("Handling ",gold(X,Y)," now.");
     !move_to(X,Y); // creates the goal of moving to the position of the gold
     pick; // action that picks the gold
     !confirm_pick; // creates the goal of confirming that the gold has been picked
     !move_to(DepotX,DepotY); // creates the goal of moving to the position of the depot
     !confirm_depot; // creates the goal of confirming that the depot is there
     drop; // action that drops the gold at the base
     .print("Finish handling ",gold(X,Y));
     !!choose_gold. // creates the goal of handling other gold pieces
```

</details>

### Task 5 - Social Ability

The team of miners has elected a leader agent, that is responsible for keeping track of the depot coordinates, and periodically moving the depot in the grid environment for safety reasons. In the Mining World GUI, observe that the depot is moved to a new position every few seconds, and the miner agent remains stuck carrying gold in the initial position of the depot (just like the stuck Roomba from the lecture). This is because the initial belief of the miner agent about the depot coordinates (`depot(0,0)`) is outdated, and the agent continues to strive confirming that it is in the location of the depot without success (lines TBA). 
    
Thankfully, agents can communicate with each other to exchange messages and share knowledge about the environment. In AgentSpeack, plan bodies can contain _communication actions_ which enable agents to communicate their beliefs and plans to each other. For example, an agent can perform the action `.send(tell, leader, sunny)` to tell the leader that it is `sunny`. 
    
Your fifth task is to update the `@manage_depot_plan` in [leader.asl](src/agt/leader.asl) so that the leader agent tells the miner agent what it believes about the depot coordinates every time the leader moves the depot.

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
    
Now the team consists of four miner agents and one leader agent. All the miner agents explore the grid environment for gold nuggets and strive to handle the perceived gold nuggets. However, only the first miner agent is being informed by the leader agent about the up-to-date depot coordinates based on your implementation of Task 5. As a result, the rest of the agents remain stuck carrying gold in the initial position of the depot.
    
Your sixth task is to update the `@manage_depot_plan` in [leader.asl](src/agt/leader.asl) so that the leader agent broadcasts what it believes about the depot coordinates every time the leader moves the depot.

In AgentSpeack, an agent, for example, can perform the action `.broadcast(tell, sunny)` to tell all the agents in a muli-agent system that it is `sunny`.

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
