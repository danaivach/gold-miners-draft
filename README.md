# Agent-Oriented Programming - Gold Miners Tutorial 

### Task 1 - Print Hello world
In `miner.asl`, l. 8-12 define the _initial beliefs and goals_ of a miner agent. The miner is initialized as follows:
- `ready_to_explore`: the agent believes that it is ready to explore the mine for gold;
- `!start`: the agent has the goal to start.

Upon initialization, the miner reacts to the creation of initial beliefs and goals. For example, the miner stives to achieve the goal `!start` by executing the `start_plan` (l. 19-21). Update the body of the `start_plan` so that the miner prints "Hello world" upon initialization.

### Task 2 - Agent beliefs for decoupling the agent from its environment
The miner agent reacts to the creation of the initial belief `ready_to_explore` by executing the `ready_to_explore_plan_1` (l.32-37). Based on the body of the plan, the miner behaves as follows:
- it computes a random position (X,Y) within the mine environment;
- it creates the goal `!explore(X,Y)` for exploring the route to (X,Y) while looking for gold.

Currently, the dimension of the mine environment (Width = 21, Height = 21) are hardcoded into the miner's plan. We can decouple the miner's plan from specific environment details with the use of _agent beliefs_ and _variables_. Visit http://localhost:3272/ to inspect which beliefs the agent acquires at run time:


Check the syntax of the agent's belief about the environment size (`env_size`) to update:
- the context of `ready_to_explore_plan_1` so that the plan is only executed when the agent has a belief `env_size(X,Y)`. Now, the plan will be applicable only if the variables X, Y become bound to specific values based on a _ground_ belief (e.g. `env_size(100, 100)`) of the miner's belief base at run time.
- the body of the plan so that the random position is computed based on the variables X, Y instead of the hardcoded values 21, 21. 


### Task 3 - Enable the agent to react to discovered gold
Currently, the agent perceives when it has discovered some gold in the environment, but it ignores it. Create a plan so that the agent reacts when it acquires the belief gold(X,Y) by behaving as follows:
- it removes the belief ready_to_move from its belief base, so that it stops moving around. 
- printing "Discorevered gold"

### Task 4 - Enable the agent to react to discovered gold within some context (optional - TBD) 
Currently, the miner can pick up all the golds that it encounters. For safety issues, the miner should be carry only one gold at a time. Update the context of your previous plan, so that the agent does not pick up another gold when the belief carrying_gold is in its belief base.

### Task 5 - Enable the agent to pursue the goal of dropping the goal in the base 
- Create a plan pickUp(gold(X,Y)) ->   !moveTo(X,Y), pick, !ensure_gold, !moveTo(BX,BY), !ensure_base, drop. 
- Update +gold to create a goal, pickUp(gold(X,Y))

###Task 6 
NOW dynamic base - try your code, it should fail
We provide failure plan for 
Create a plan on the leader to react to +base_position() by informing the miner about the base_position.

### Task 7
NOW many miners 
try your code, it should fail for all but 1 agent
Update the previous plan on the leader so that it broadcasts.

