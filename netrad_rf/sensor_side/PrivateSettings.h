// NOTE
// Before uploading to your Arduino board,
// please replace with your own settings

// NetRAD pinouts - this is specific to the NetRAD board
int pinSpkr = 6;            // pin number of piezo speaker
int pinLED = 7;             // pin number of event LED

// Update interval in minutes
const int publishIntervalInMinutes = 1;

enum TubeModel {
  LND_712, // LND
  SBM_20, // GSTube
  J408GAMMA, // North Optic
  J306BETA, // North Optic
  INSPECTOR,
  CRM100
};

// Tube model
const TubeModel tubeModel = SBM_20;

// Interrupt mode:
// * For most geiger counter modules: FALLING
// * Geiger Counter Twig by Seeed Studio: RISING
const int interruptMode = RISING;

