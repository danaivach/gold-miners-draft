# Programming your first Agent - Gold Miners Tutorial 

## Table of Contents
-   [How to run the project](#how-to-run-the-project)
-   [Gold Miners Tutorial](#gold-miners-tutorial)
    -  [Task 1 - Hello World](#task-1---hello-world)
    -  [Task 2 - Beliefs about the world](#task-2---agent-beliefs-for-decoupling-the-agent-from-its-environment)
    -  [Task 3 - Reactive behavior](#task-3---enable-the-agent-to-react-to-discovered-gold)
    -  [Task 4 - Proactive behavior](#task-4---enable-the-agent-to-pursue-the-goal-of-picking-gold-and-dropping-gold-in-the-base)
    -  [Task 5 - Social ability]()
    -  [Task 6 - Towards Multi-Agent Systems]()

## How to run the project
Run with [Gradle 7.4](https://gradle.org/): 
- MacOS and Linux: run the following commands
- Windows: replace `./gradlew` with `gradlew.bat`

For Tasks 1-4:
```shell
./gradlew mas-reactive-proactive
```
For Task 5:
```shell
./gradlew mas-social-ability
```
For Task 6: 
```shell
./gradlew mas-multi-agent
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

### Task 2 - Agent beliefs for decoupling the agent from its environment
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

### Task 3 - Enable the agent to react to discovered gold
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

### Task 4 - Enable the agent to pursue the goal of picking gold and dropping gold in the base 
Even though the agent perceives gold in the environment, it cannot achieve to pick it up and drop it in the mine base.

Update `handle_gold_plan` that enables the agent to pursue the goal of picking the perceived gold and drop it in the base by behaving as as foolows:
- the plan is triggered by the creation of the goal `!handle_gold(gold(X,Y))` (triggering event: `+!handle_gold(gold(X,Y))`)
- the plan is applicable when the agent is []
- Create a plan pickUp(gold(X,Y)) ->   !moveTo(X,Y), pick, !ensure_gold, !moveTo(BX,BY), !ensure_base, drop. 
- Update +gold to create a goal, pickUp(gold(X,Y))

###Task 5 (TBD)
NOW dynamic base - try your code, it should fail
We provide failure plan for 
Create a plan on the leader to react to +base_position() by informing the miner about the base_position.

### Task 6 (TBD)
NOW many miners 
try your code, it should fail for all but 1 agent
Update the previous plan on the leader so that it broadcasts.

