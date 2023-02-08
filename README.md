# gold-miners-draft

### Task 1 - Hello world
Print "hello world" at the @start plan of the agent.

### Task 2 - Decouple the agent from the environment features
Currently, the knowledge about the size of the environment is hardcoded in the behavior of the agent. Update the context of the plan @ready_to_move so that the agent takes into consideration its belief (env_size(Width, Height)) about the environment size.   

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

