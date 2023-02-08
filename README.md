# gold-miners-draft

### Task 1 - Hello world
Print "hello world" at the @start plan of the agent.

### Task 2 - Decouple the agent from the environment features
Currently, the knowledge about the size of the environment is hardcoded in the behavior of the agent. Update the context of the plan @ready_to_move so that the agent takes into consideration its run-time belief (env_size(Width, Height)) about the environment size.   

### Task 3 - Enable the agent to react to discovered gold
Currently, the agent perceives when it has discovered some gold in the environment, but it ignores it. Create a plan so that the agent reacts when it acquires the belief gold(X,Y) by behaving as follows:
- it removes the belief ready_to_move from its belief base, so that it stops moving around. 
- it adds a goal achievement event pick_up(gold(X,Y)) to its event queue.

### Task 5 - Enable the agent to react to discovered gold within some context
Currently, the miner can pick up all the golds that it encounters. For safety issues, the miner should be carry only one gold at a time. Update the context of your previous plan, so that the agent does not pick up another gold when the belief carrying_gold is in its belief base.

### Task 6 - Enable the agent to pursue the goal of dropping the goal in the base
Currently, the miner picks up the gold but it does not drop it in the base. Create a plan so that the agent reacts in the event of the goal achievement addition +!drop, by going to position (0,0). 

### Task 7 -  Decouple the agent from the environment state
Currently, the miner cannot handle the dynamics of the environment in case the base is moved. Update the context of your previous plan so that the agent takes into consideration its current belief about the position of the base.

### Task 8 -  Enable the agent to socialize (I)
send 

### Task 9 -  Enable the agent to socialize (II)
broadcast
