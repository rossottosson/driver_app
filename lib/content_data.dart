// lib/content_data.dart

// --- The NEW Theory Data Structure using a list of content blocks ---
final Map<String, Map<String, dynamic>> theoryData = {
  '1': {
    'title': 'Chapter 1: Road Signs', // This remains the AppBar title
    'contentBlocks': [
      {
        'type': 'heading',
        'content': 'Understanding Sign Types',
      },
      {
        'type': 'paragraph',
        'content': 'Road signs are divided into several categories. The main types are Regulatory, Warning, and Informational signs. Each has a distinct shape and color to help drivers quickly understand their meaning.',
      },
      {
        'type': 'heading',
        'content': 'Regulatory Signs',
      },
      {
        'type': 'paragraph',
        'content': 'Regulatory signs enforce laws. You must obey them. They include signs like Speed Limit signs and No Parking signs. Here is a very common example:',
      },
      {
        'type': 'image',
        'content': 'assets/images/stop_sign.png',
      },
       {
        'type': 'paragraph',
        'content': 'The STOP sign is an octagonal regulatory sign that requires you to come to a complete stop at the marked line before proceeding safely.',
      },
    ]
  },
  '2': {
    'title': 'Chapter 2: Warning Signs',
    'contentBlocks': [
       {
        'type': 'heading',
        'content': 'Identifying Hazards',
      },
      {
        'type': 'paragraph',
        'content': 'Warning signs are usually diamond-shaped with a yellow background. They are designed to warn you of potential hazards or changes in road conditions ahead. Here are two examples:',
      },
      {
        'type': 'image',
        'content': 'assets/images/curve_sign.png',
      },
       {
        'type': 'image',
        'content': 'assets/images/slippery_road_sign.png',
      },
    ]
  },
  '3': {
    'title': 'Chapter 3: Parking Rules',
    'contentBlocks': [
       {
        'type': 'paragraph',
        'content': 'Parking signs indicate where you can and cannot park, and for how long. A green sign typically indicates permitted parking, while a red sign indicates restrictions or prohibitions.',
      },
       {
        'type': 'image',
        'content': 'assets/images/parking_sign.png',
      },
    ]
  },
  'End': {
    'title': 'Congratulations!',
    'contentBlocks': [
       {
        'type': 'heading',
        'content': 'You\'ve Finished!',
      },
      {
        'type': 'paragraph',
        'content': 'You have completed all the theory chapters. You can now use the Practice Test section to prepare for your exam. Good luck!',
      },
       {
        'type': 'image',
        'content': 'assets/images/congrats.png',
      },
    ]
  },
};


// --- The Expanded Central Question Bank ---
final List<Map<String, dynamic>> questionBank = [
  // Category: Road Signs (12 Questions)
  {
    'id': 'sign_001', 'category': 'Road Signs',
    'question': 'What type of sign is a STOP sign?',
    'imagePaths': ['assets/images/stop_sign.png'],
    'options': ['Warning Sign', 'Regulatory Sign', 'Informational Sign'],
    'correctAnswerIndex': 1,
    'explanation': 'The stop sign is a regulatory sign because it enforces a traffic law that you must obey.',
  },
  {
    'id': 'sign_002', 'category': 'Road Signs',
    'question': 'This sign indicates:',
    'imagePaths': ['assets/images/slippery_road_sign.png'],
    'options': ['Road Narrows', 'Slippery When Wet', 'Winding Road'],
    'correctAnswerIndex': 1,
    'explanation': 'This is a warning sign, indicating that the road surface may be slippery, especially during or after rain.',
  },
  {
    'id': 'sign_003', 'category': 'Road Signs',
    'question': 'What does a triangular YIELD sign mean?', 'imagePaths': [],
    'options': ['Stop completely', 'Merge left immediately', 'Slow down and give way to other traffic'], 'correctAnswerIndex': 2,
    'explanation': 'A yield sign means you must slow down or stop if necessary to give the right-of-way to traffic on the road you are entering.',
  },
  {
    'id': 'sign_004', 'category': 'Road Signs',
    'question': 'What shape is a school zone warning sign?', 'imagePaths': [],
    'options': ['Circular', 'Octagonal', 'Pentagonal (five-sided)'], 'correctAnswerIndex': 2,
    'explanation': 'School zone and school crossing signs are pentagon-shaped to be easily recognizable.',
  },
  {
    'id': 'sign_005', 'category': 'Road Signs',
    'question': 'A diamond-shaped sign with a picture of a deer indicates what?', 'imagePaths': [],
    'options': ['Hunting area ahead', 'Animal crossing ahead', 'Zoo or park entrance'], 'correctAnswerIndex': 1,
    'explanation': 'This is a warning sign alerting drivers that they are in an area with a high population of deer that may cross the road.',
  },
  {
    'id': 'sign_006', 'category': 'Road Signs',
    'question': 'A round traffic sign usually indicates a...', 'imagePaths': [],
    'options': ['...stop sign ahead.', '...railway crossing ahead.', '...speed limit change.'], 'correctAnswerIndex': 1,
    'explanation': 'Round, yellow warning signs are commonly used to give advanced warning of a railway crossing.',
  },
   {
    'id': 'sign_007', 'category': 'Road Signs',
    'question': 'A rectangular sign with a white background and a red circle with a line through a "P" means:', 'imagePaths': [],
    'options': ['Parking permitted', 'Paid parking zone', 'No Parking'], 'correctAnswerIndex': 2,
    'explanation': 'This is a standard regulatory sign indicating that parking is prohibited in this area.',
  },
  {
    'id': 'sign_008', 'category': 'Road Signs',
    'question': 'An arrow sign with a sharp bend to the right warns of what?', 'imagePaths': ['assets/images/curve_sign.png'],
    'options': ['A roundabout ahead', 'A sharp curve to the right', 'You must turn right'], 'correctAnswerIndex': 1,
    'explanation': 'This is a warning sign indicating a sharp curve in the road ahead, advising drivers to slow down.',
  },
  {
    'id': 'sign_009', 'category': 'Road Signs',
    'question': 'What does a "No U-Turn" sign mean?', 'imagePaths': [],
    'options': ['You cannot turn left', 'You cannot make a 180-degree turn', 'The road ahead is closed'], 'correctAnswerIndex': 1,
    'explanation': 'This regulatory sign prohibits drivers from making a U-turn to go back in the opposite direction.',
  },
  {
    'id': 'sign_010', 'category': 'Road Signs',
    'question': 'A square blue sign with a white "H" on it indicates:', 'imagePaths': [],
    'options': ['Helicopter landing pad', 'Highway entrance', 'Hospital nearby'], 'correctAnswerIndex': 2,
    'explanation': 'Blue signs are typically informational signs. An "H" sign directs drivers to a nearby hospital.',
  },
  {
    'id': 'sign_011', 'category': 'Road Signs',
    'question': 'A sign showing two arrows pointing in opposite vertical directions warns of:', 'imagePaths': [],
    'options': ['A one-way street', 'Two-way traffic ahead', 'A divided highway ending'], 'correctAnswerIndex': 1,
    'explanation': 'This sign is used to warn drivers that they are leaving a one-way street and entering a road with traffic moving in both directions.',
  },
  {
    'id': 'sign_012', 'category': 'Road Signs',
    'question': 'A sign with a number inside a red circle on a white background indicates:', 'imagePaths': ['assets/images/speed_limit_sign.png'],
    'options': ['A suggested speed', 'The maximum speed limit', 'A highway route number'], 'correctAnswerIndex': 1,
    'explanation': 'This is a regulatory sign that indicates the maximum legal speed you can travel on that section of road under ideal conditions.',
  },
  
  // Category: Road Rules (15 Questions)
  {
    'id': 'rule_001', 'category': 'Road Rules',
    'question': 'When approaching a roundabout, you must give way to:', 'imagePaths': [],
    'options': ['Traffic on your right', 'All traffic already in the roundabout', 'All traffic on your left'], 'correctAnswerIndex': 1,
    'explanation': 'You must always give way (yield) to any vehicles already circulating within the roundabout before entering.',
  },
  {
    'id': 'rule_002', 'category': 'Road Rules',
    'question': 'What is a safe following distance under normal conditions?', 'imagePaths': [],
    'options': ['One car length', 'The 3-second rule', 'As close as possible'], 'correctAnswerIndex': 1,
    'explanation': 'The 3-second rule helps you maintain a safe distance. Watch the vehicle ahead pass a fixed point and count three seconds; if you pass the point before then, you are too close.',
  },
  {
    'id': 'rule_003', 'category': 'Road Rules',
    'question': 'At an intersection with a flashing yellow traffic light, you should:', 'imagePaths': [],
    'options': ['Stop completely before proceeding', 'Proceed with caution', 'Speed up to clear the intersection'], 'correctAnswerIndex': 1,
    'explanation': 'A flashing yellow light acts as a warning sign. You do not need to stop, but you must slow down and proceed through the intersection with caution.',
  },
  {
    'id': 'rule_004', 'category': 'Road Rules',
    'question': 'Before changing lanes, what is the correct sequence of actions?', 'imagePaths': [],
    'options': ['Signal, check mirrors, check blind spot', 'Check blind spot, signal, check mirrors', 'Check mirrors, check blind spot, signal'], 'correctAnswerIndex': 0,
    'explanation': 'The correct and safest sequence is to first indicate your intention (signal), then check your mirrors, and finally check your blind spot for any unseen vehicles before making the move.',
  },
  {
    'id': 'rule_005', 'category': 'Road Rules',
    'question': 'At a four-way stop, who has the right-of-way?', 'imagePaths': [],
    'options': ['The largest vehicle', 'The vehicle that arrives first', 'The vehicle to the right'], 'correctAnswerIndex': 1,
    'explanation': 'At a four-way stop, the first vehicle to arrive and stop has the right-of-way. If two vehicles arrive at the same time, the vehicle on the right goes first.',
  },
  {
    'id': 'rule_006', 'category': 'Road Rules',
    'question': 'A solid white line on the road means:', 'imagePaths': [],
    'options': ['You may change lanes with caution', 'You should not change lanes', 'The road is ending'], 'correctAnswerIndex': 1,
    'explanation': 'A solid white line indicates that lane changes are discouraged or prohibited. You should stay in your lane.',
  },
  {
    'id': 'rule_007', 'category': 'Road Rules',
    'question': 'What should you do when a traffic light turns from green to yellow?', 'imagePaths': [],
    'options': ['Speed up to make it through', 'Prepare to stop as the light is about to turn red', 'Stop immediately, even in the intersection'], 'correctAnswerIndex': 1,
    'explanation': 'A steady yellow light is a warning that the light is about to change to red. You should slow down and prepare to stop safely before the intersection.',
  },
  {
    'id': 'rule_008', 'category': 'Road Rules',
    'question': 'Is it permissible to use a hand-held mobile phone while driving?', 'imagePaths': [],
    'options': ['Yes, if the conversation is short', 'Only when stopped at a red light', 'No, it is illegal and unsafe'], 'correctAnswerIndex': 2,
    'explanation': 'Using a hand-held mobile phone while driving is illegal in most places due to the significant distraction it causes.',
  },
  {
    'id': 'rule_009', 'category': 'Road Rules',
    'question': 'When are you required to use your headlights?', 'imagePaths': [],
    'options': ['Only after midnight', 'From 30 minutes after sunset to 30 minutes before sunrise', 'Only when it is raining'], 'correctAnswerIndex': 1,
    'explanation': 'Headlights are required during hours of darkness and any other time visibility is poor, typically defined as from sunset to sunrise.',
  },
   {
    'id': 'rule_010', 'category': 'Road Rules',
    'question': 'What does a broken yellow line down the center of the road indicate?', 'imagePaths': [],
    'options': ['Passing is not allowed', 'Passing is allowed for your side if the way is clear', 'It marks the right edge of the pavement'], 'correctAnswerIndex': 1,
    'explanation': 'A broken yellow line separates lanes of traffic moving in opposite directions. You may pass a vehicle in front of you if the way is clear.',
  },
  {
    'id': 'rule_011', 'category': 'Road Rules',
    'question': 'Who has the right-of-way at an uncontrolled intersection?', 'imagePaths': [],
    'options': ['The vehicle on the left', 'The faster vehicle', 'The vehicle on the right'], 'correctAnswerIndex': 2,
    'explanation': 'At an intersection with no signs or signals, you must yield to vehicles on your right.',
  },
  {
    'id': 'rule_012', 'category': 'Road Rules',
    'question': 'When a school bus is stopped with its red lights flashing, you must:', 'imagePaths': [],
    'options': ['Slow down and pass carefully', 'Stop, regardless of your direction of travel', 'Honk to let them know you are passing'], 'correctAnswerIndex': 1,
    'explanation': 'You must stop for a stopped school bus with flashing red lights, unless you are on the opposite side of a divided highway.',
  },
  {
    'id': 'rule_013', 'category': 'Road Rules',
    'question': 'What is the "blind spot" for a driver?', 'imagePaths': [],
    'options': ['The area directly in front of the car', 'The area behind the car visible in the rearview mirror', 'The area around the car not visible in the mirrors'], 'correctAnswerIndex': 2,
    'explanation': 'The blind spot is the area to the sides of your vehicle that cannot be seen in your side or rearview mirrors. You must physically turn your head to check it.',
  },
  {
    'id': 'rule_014', 'category': 'Road Rules',
    'question': 'It is illegal to make a U-turn...', 'imagePaths': [],
    'options': ['...on a highway or near the crest of a hill.', '...in a residential area.', '...at any intersection.'], 'correctAnswerIndex': 0,
    'explanation': 'U-turns are dangerous and often illegal where visibility is limited, such as on highways, in tunnels, or near the top of a hill.',
  },
  {
    'id': 'rule_015', 'category': 'Road Rules',
    'question': 'What is the first thing to be affected by alcohol consumption?', 'imagePaths': [],
    'options': ['Vision', 'Judgment', 'Motor skills'], 'correctAnswerIndex': 1,
    'explanation': 'Alcohol is a depressant that affects your brain first. One of the first functions to be impaired is judgment and decision-making.',
  },
  
  // Category: Parking (10 Questions)
  {
    'id': 'park_001', 'category': 'Parking',
    'question': 'A sign with a green circle generally means:', 'imagePaths': [],
    'options': ['Parking is prohibited', 'Action is permitted', 'Yield to traffic'], 'correctAnswerIndex': 1,
    'explanation': 'Green signs or circles typically indicate that a movement is permitted, or give directional guidance.',
  },
  {
    'id': 'park_002', 'category': 'Parking',
    'question': 'When parking uphill on a street with a curb, which way should you turn your front wheels?', 'imagePaths': [],
    'options': ['Towards the curb', 'Straight ahead', 'Away from the curb'], 'correctAnswerIndex': 2,
    'explanation': 'Turn your wheels away from the curb. If your car rolls backwards, the front tire will hit the curb and stop the car.',
  },
  {
    'id': 'park_003', 'category': 'Parking',
    'question': 'When parking downhill on a street with a curb, which way should you turn your front wheels?', 'imagePaths': [],
    'options': ['Away from the curb', 'Towards the curb', 'Straight ahead'], 'correctAnswerIndex': 1,
    'explanation': 'Turn your wheels towards the curb. If your car rolls forwards, the front tire will hit the curb and stop the car.',
  },
  {
    'id': 'park_004', 'category': 'Parking',
    'question': 'What does a painted yellow curb mean?', 'imagePaths': [],
    'options': ['Loading zone for commercial vehicles', 'Free public parking', 'Passenger pickup/dropoff only'], 'correctAnswerIndex': 0,
    'explanation': 'A yellow curb often indicates a commercial loading zone or a specific time-limited stopping area. Check nearby signs for specific rules.',
  },
  {
    'id': 'park_005', 'category': 'Parking',
    'question': 'How close can you legally park to a fire hydrant?', 'imagePaths': [],
    'options': ['As close as you want', 'Depends on the country, but never right next to it', 'At least 10 meters away'], 'correctAnswerIndex': 1,
    'explanation': 'The distance varies by location (e.g., 3 meters in some places, 15 feet in others), but it is always illegal to park too close to a fire hydrant and obstruct access.',
  },
  {
    'id': 'park_006', 'category': 'Parking',
    'question': 'What is "double parking"?', 'imagePaths': [],
    'options': ['Parking in a two-car garage', 'Parking for two hours', 'Parking alongside a car that is already parked at the curb'], 'correctAnswerIndex': 2,
    'explanation': 'Double parking is illegal and dangerous as it obstructs a lane of traffic.',
  },
   {
    'id': 'park_007', 'category': 'Parking',
    'question': 'Is it legal to park in front of a private driveway?', 'imagePaths': [],
    'options': ['Yes, if you are just waiting', 'Only for a few minutes', 'No, you cannot block access'], 'correctAnswerIndex': 2,
    'explanation': 'Blocking a private or public driveway is illegal as it prevents vehicles from entering or exiting.',
  },
  {
    'id': 'park_008', 'category': 'Parking',
    'question': 'What does a painted red curb signify?', 'imagePaths': [],
    'options': ['Short-term parking', 'Fire lane - no stopping or parking', 'Passenger loading zone'], 'correctAnswerIndex': 1,
    'explanation': 'A red curb indicates that stopping, standing, or parking is prohibited, often because it is a designated fire lane.',
  },
  {
    'id': 'park_009', 'category': 'Parking',
    'question': 'When parallel parking, how far can your wheels be from the curb?', 'imagePaths': [],
    'options': ['As far as needed', 'A maximum of one meter', 'Generally no more than 30cm (12 inches)'], 'correctAnswerIndex': 2,
    'explanation': 'To be legally parked, your vehicle must be close to the curb, typically within 30cm or 12 inches, to avoid obstructing traffic.',
  },
  {
    'id': 'park_010', 'category': 'Parking',
    'question': 'You are looking for a parking spot. What should you be mindful of?', 'imagePaths': [],
    'options': ['Only the empty spots', 'The traffic behind you', 'The color of the other cars'], 'correctAnswerIndex': 1,
    'explanation': 'When searching for parking, it is crucial to remain aware of the traffic around you, especially vehicles behind you that may not expect you to slow down or stop suddenly.',
  },

  // Category: Night Driving (5 questions)
  {
    'id': 'night_001', 'category': 'Night Driving',
    'question': 'When should you dip your high beams for an oncoming vehicle?', 'imagePaths': [],
    'options': ['50 meters away', '150 meters away', 'As soon as you see them'], 'correctAnswerIndex': 1,
    'explanation': 'To avoid dazzling other drivers, you must dip your high beams at least 150 meters before meeting another vehicle.',
  },
  {
    'id': 'night_002', 'category': 'Night Driving',
    'question': 'What does "overdriving your headlights" mean?', 'imagePaths': [],
    'options': ['Driving so fast you cannot stop within the distance your lights illuminate', 'Using high beams in a well-lit urban area', 'Forgetting to turn your headlights on'], 'correctAnswerIndex': 0,
    'explanation': 'Overdriving your headlights means your stopping distance is longer than the area illuminated by your lights, which is very dangerous.',
  },
  {
    'id': 'night_003', 'category': 'Night Driving',
    'question': 'If an oncoming vehicle has its high beams on, you should:', 'imagePaths': [],
    'options': ['Turn your own high beams on', 'Look directly at their lights to show them', 'Look to the right edge of your lane or the painted line'], 'correctAnswerIndex': 2,
    'explanation': 'Never stare into oncoming high beams. Avert your gaze to the right edge of the road to guide your car and avoid being blinded.',
  },
  {
    'id': 'night_004', 'category': 'Night Driving',
    'question': 'Why is it more dangerous to drive at night?', 'imagePaths': [],
    'options': ['There are more cars on the road', 'Your visibility is significantly reduced', 'The road is more slippery'], 'correctAnswerIndex': 1,
    'explanation': 'Reduced visibility is the single biggest danger of night driving. You see less of the road ahead and have less time to react to hazards.',
  },
   {
    'id': 'night_005', 'category': 'Night Driving',
    'question': 'When should you use your fog lights?', 'imagePaths': [],
    'options': ['Whenever it is dark', 'Only in heavy fog or poor visibility, and turn them off when visibility improves', 'During any amount of rain'], 'correctAnswerIndex': 1,
    'explanation': 'Fog lights are powerful and can dazzle other drivers. They should only be used in conditions of severely reduced visibility like fog or heavy snow, and turned off when conditions clear.',
  },
  
  // Category: Vehicle Safety (5 questions)
  {
    'id': 'safe_001', 'category': 'Vehicle Safety',
    'question': 'What is the primary purpose of head restraints in a car?', 'imagePaths': [],
    'options': ['To provide comfort for the neck', 'To prevent whiplash in a rear-end collision', 'To improve the car\'s aerodynamics'], 'correctAnswerIndex': 1,
    'explanation': 'Head restraints are a critical safety feature designed to limit the backward movement of the head during a rear-end crash, thereby preventing or reducing the severity of whiplash.',
  },
  {
    'id': 'safe_002', 'category': 'Vehicle Safety',
    'question': 'What does ABS stand for in a vehicle?', 'imagePaths': [],
    'options': ['Automatic Braking System', 'Anti-lock Braking System', 'Advanced Balancing System'], 'correctAnswerIndex': 1,
    'explanation': 'ABS prevents the wheels from locking up during hard braking, allowing the driver to maintain steering control.',
  },
  {
    'id': 'safe_003', 'category': 'Vehicle Safety',
    'question': 'Hydroplaning is most likely to occur when?', 'imagePaths': [],
    'options': ['Driving on a dry, sunny day', 'Driving through deep water at high speed', 'Driving on a gravel road'], 'correctAnswerIndex': 1,
    'explanation': 'Hydroplaning happens when a layer of water builds between the tires and the road surface, leading to a loss of traction. It is most common when driving too fast for wet conditions.',
  },
  {
    'id': 'safe_004', 'category': 'Vehicle Safety',
    'question': 'How often should you check your tire pressure?', 'imagePaths': [],
    'options': ['Once a year', 'Only when they look flat', 'At least once a month and before long trips'], 'correctAnswerIndex': 2,
    'explanation': 'Proper tire pressure is crucial for safety, fuel efficiency, and tire longevity. Checking it monthly is a recommended practice.',
  },
  {
    'id': 'safe_005', 'category': 'Vehicle Safety',
    'question': 'When adjusting your mirrors, you should set them to see:', 'imagePaths': [],
    'options': ['A large portion of the side of your car', 'The road directly behind you', 'A small sliver of the side of your car, and mostly the lane next to you'], 'correctAnswerIndex': 2,
    'explanation': 'This setting minimizes your blind spot. You should see just a tiny edge of your own car to orient yourself, with the rest of the mirror covering the adjacent lane.',
  },
  
  // Category: Emergencies (5 questions)
  {
    'id': 'emer_001', 'category': 'Emergencies',
    'question': 'If your car\'s brakes fail completely, what is one of the first things you should do?', 'imagePaths': [],
    'options': ['Turn off the engine immediately', 'Pump the brake pedal quickly and firmly', 'Open the car door to use your foot'], 'correctAnswerIndex': 1,
    'explanation': 'Pumping the brake pedal can build up enough pressure in the brake lines to stop the car. If that fails, you should use the emergency brake and downshift.',
  },
  {
    'id': 'emer_002', 'category': 'Emergencies',
    'question': 'You see an emergency vehicle with flashing lights and a siren approaching from behind. What should you do?', 'imagePaths': [],
    'options': ['Speed up to get out of its way', 'Stop immediately in your current lane', 'Pull over to the right side of the road and stop'], 'correctAnswerIndex': 2,
    'explanation': 'The law requires you to yield the right-of-way to emergency vehicles by pulling over to the right as safely and quickly as possible and stopping until it has passed.',
  },
  {
    'id': 'emer_003', 'category': 'Emergencies',
    'question': 'If you have a tire blowout while driving, you should:', 'imagePaths': [],
    'options': ['Brake hard immediately', 'Grip the steering wheel firmly and steer straight', 'Quickly swerve to the shoulder'], 'correctAnswerIndex': 1,
    'explanation': 'Do not slam on the brakes. Hold the steering wheel tightly to maintain control, release the accelerator, and gently guide your car to the side of the road once it has slowed down.',
  },
  {
    'id': 'emer_004', 'category': 'Emergencies',
    'question': 'If your car starts to skid, you should:', 'imagePaths': [],
    'options': ['Steer in the opposite direction of the skid', 'Brake as hard as possible', 'Steer in the direction you want the car to go'], 'correctAnswerIndex': 2,
    'explanation': 'Look and steer in the direction you want to go. Do not brake hard or oversteer, as this can make the skid worse.',
  },
  {
    'id': 'emer_005', 'category': 'Emergencies',
    'question': 'You are the first to arrive at a crash scene. After ensuring your own safety, what is the first thing you should do?', 'imagePaths': [],
    'options': ['Start directing traffic', 'Call emergency services (e.g., 112)', 'Take photos for insurance'], 'correctAnswerIndex': 1,
    'explanation': 'The first and most critical action is to call for professional help. Provide the location and details of the crash to the emergency dispatcher.',
  },
];


// The Journey Quizzes now just reference question IDs from the bank
final Map<String, Map<String, dynamic>> quizData = {
  'Q1': {
    'title': 'Quiz on Road Signs',
    'questionIds': ['sign_001', 'sign_002', 'sign_004', 'sign_012'],
  },
  'Q2': {
    'title': 'Quiz on Road Rules',
    'questionIds': ['rule_001', 'rule_004', 'rule_006', 'rule_011'],
  },
  'Q3': {
    'title': 'Quiz on Safety & Emergencies',
    'questionIds': ['safe_002', 'safe_003', 'emer_001', 'emer_003'],
  },
};