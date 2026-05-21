import matplotlib.pyplot as plt

class NeuronRef:
    def __init__(self, name, neuron_id, threshold_init=-30.0, membrane_init=-50.0, v_max=40.0, v_min=-90.0, t_max=0.0):
        self.name = name
        self.neuron_id = neuron_id
        self.v_init = float(membrane_init)
        self.t_init = float(threshold_init)
        self.v_max = float(v_max)
        self.v_min = float(v_min)
        self.t_max = float(t_max)
        
        self.v = self.v_init
        self.threshold = self.t_init
        self.spike = 0

    def step(self, input_weight, weight_valid, bus_done):
        if self.spike == 1:
            self.spike = 0
            self.v = self.v_init
            self.threshold = self.threshold - (self.threshold / 8.0)
            if self.threshold > self.t_max:
                self.threshold = self.t_max
        else:
            membrane_copy = self.v
            
            if weight_valid:
                membrane_copy = self.v + input_weight
            
            if membrane_copy > self.v_max:
                membrane_copy = self.v_max
            elif membrane_copy < self.v_min:
                membrane_copy = self.v_min
            
            current_leak = (self.v - self.v_init) / 16.0

            if bus_done:
                if membrane_copy >= self.threshold:
                    self.spike = 1
                    self.v = membrane_copy
                else:
                    self.spike = 0
                    self.v = membrane_copy - current_leak
                    if self.threshold > self.t_init:
                        t_copy = self.threshold + (self.threshold / 32.0)
                        if t_copy < self.t_init:
                            self.threshold = self.t_init
                        else:
                            self.threshold = t_copy
            else:
                self.v = membrane_copy
                self.spike = 0

weights_matrix = {
    0: [0.0, -2.0,  0.0,  1.0],  # ALML 
    1: [0.0,  8.0,  1.0,  7.0],  # PVCR
    2: [0.0,  0.0,  2.0,  7.0],  # AVBL
    3: [0.0,  1.0,  0.0, 15.0],  # AVDR
    4: [0.0,  0.0,  2.0,  0.0]   # AVAR
}

neurons = [
    NeuronRef("PVCR", neuron_id=1),
    NeuronRef("AVBL", neuron_id=2),
    NeuronRef("AVDR", neuron_id=3),
    NeuronRef("AVAR", neuron_id=4)
]

TOTAL_CYCLES = 150
history = {n.name: {'v': [], 't': [], 's': []} for n in neurons}
history['ALML'] = []

fsm_state = "INITIAL"
spike_bus_signal = [0] * 5
fsm_index = 0
fsm_neuron_address = 0
weight_valid = False
bus_done = False

tb_state = "DRIVE_SPIKE" 

for clk in range(TOTAL_CYCLES):
    
    if clk == 0:
        rst = True
        current_external_spike = 0
    else:
        rst = False
        if tb_state == "DRIVE_SPIKE":
            current_external_spike = 1
            if bus_done: 
                tb_state = "CLEAR_SPIKE"
        elif tb_state == "CLEAR_SPIKE":
            current_external_spike = 0
            tb_state = "DRIVE_SPIKE"

    for i, n in enumerate(neurons):
        history[n.name]['v'].append(n.v)
        history[n.name]['t'].append(n.threshold)
        history[n.name]['s'].append(n.spike)
    history['ALML'].append(current_external_spike)

    next_state = fsm_state
    next_fsm_neuron_address = fsm_neuron_address
    weight_valid_out = 0
    bus_done_out = 0
    
    if fsm_state == "INITIAL":
        bus_done_out = 0
        weight_valid_out = 0
        if not rst:
            spike_bus = [current_external_spike] + [n.spike for n in neurons]
            spike_bus_signal = list(spike_bus)
            fsm_index = 0
            next_fsm_neuron_address = 0
            next_state = "BUS_COMPARE"
        
    elif fsm_state == "BUS_COMPARE":
        if fsm_index >= 5:
            next_state = "ADD_WEIGHTS"
        else:
            if spike_bus_signal[fsm_index] == 1:
                next_fsm_neuron_address = fsm_index
                spike_bus_signal[fsm_index] = 0
                next_state = "WAIT_BRAM"
            else:
                fsm_index += 1
                next_state = "BUS_COMPARE"
                
    elif fsm_state == "WAIT_BRAM":
        next_state = "ASSERT_WEIGHT"
        
    elif fsm_state == "ASSERT_WEIGHT":
        weight_valid_out = 1
        fsm_index += 1
        next_state = "BUS_COMPARE"
        
    elif fsm_state == "ADD_WEIGHTS":
        bus_done_out = 1
        next_state = "INITIAL"

    for i, n in enumerate(neurons):
        current_weight = weights_matrix[fsm_neuron_address][i] if weight_valid else 0.0
        n.step(current_weight, weight_valid, bus_done)
        
    if rst:
        fsm_state = "INITIAL"
        fsm_neuron_address = 0
        weight_valid = False
        bus_done = False
    else:
        fsm_state = next_state
        fsm_neuron_address = next_fsm_neuron_address
        weight_valid = (weight_valid_out == 1)
        bus_done = (bus_done_out == 1)

##########
fig, axes = plt.subplots(4, 1, figsize=(12, 10), sharex=True)
fig.suptitle('Simulation', fontsize=14, fontweight='bold')

for i, n in enumerate(neurons):
    ax = axes[i]
    ax.plot(history[n.name]['v'], label=f'{n.name} Membrane', color='blue')
    ax.plot(history[n.name]['t'], label=f'{n.name} Threshold', color='red', linestyle='--')
    
    ax.set_ylabel('Membrane potential (mV)')
    ax.grid(True, linestyle=':', alpha=0.6)
    ax.legend(loc='upper right')

axes[-1].set_xlabel('Cycles')
plt.tight_layout()
plt.show()