% Initialize Webots communication
wb_robot_init();

wb_robot_step(1000);

% Constants
TIME_STEP = 64;
MAX_SPEED = 26.0; % Adjust the maximum speed as needed

% Motor names
names = {'left motor 1', 'left motor 2', 'left motor 3', 'left motor 4', 'right motor 1', 'right motor 2', 'right motor 3', 'right motor 4'};

% Get motor tags
motors = zeros(1, 8);
for i = 1:8
    motors(i) = wb_robot_get_device(names{i});
    wb_motor_set_position(motors(i), inf);
end

% Define obstacle avoidance parameters
OBSTACLE_THRESHOLD = 100; % Adjust as needed
OBSTACLE_AVOID_SPEED = 3; % Adjust as needed

% Initialize proximity sensors
proximity_sensors = zeros(1, 8);
sensor_names = {'ps0', 'ps1', 'ps2', 'ps3', 'ps4', 'ps5', 'ps6', 'ps7'}; % Add the names of your proximity sensors here
for i = 1:8
    proximity_sensors(i) = wb_robot_get_device(sensor_names{i});
    wb_distance_sensor_enable(proximity_sensors(i), TIME_STEP);
end

while wb_robot_step(TIME_STEP) ~= -1
    % Read proximity sensor values
    sensor_values = zeros(1, 8);
    for i = 1:8
        sensor_values(i) = wb_distance_sensor_get_value(proximity_sensors(i));
    end
    
    % Write sensor values to the console
    fprintf('Sensor values: ');
    for i = 1:8
        fprintf('%d ', sensor_values(i));
    end
    fprintf('\n');
    
    % Check if obstacles are detected
    if any(sensor_values > OBSTACLE_THRESHOLD)
        % Obstacle detected, perform obstacle avoidance
        left_speed = MAX_SPEED - OBSTACLE_AVOID_SPEED;
        right_speed = MAX_SPEED + OBSTACLE_AVOID_SPEED;
    else
        % No obstacle, move forward
        left_speed = MAX_SPEED;
        right_speed = MAX_SPEED;
    end
    
    % Set motor velocities individually
    for i = 1:4
       wb_motor_set_velocity(motors(i), left_speed);
    end

    for i = 5:8
       wb_motor_set_velocity(motors(i), right_speed);
    end
end

wb_robot_cleanup();
