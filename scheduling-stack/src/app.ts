import * as aws from 'aws-sdk';
const EC2 = new aws.EC2({
  region: 'eu-west-2'
});

type State = 'ON' | 'OFF';
type InstanceState =
  | 'pending'
  | 'running'
  | 'shutting-down'
  | 'terminated'
  | 'stopping'
  | 'stopped';

interface StateAtTime {
  time: number;
  state: State;
}

function ok() {
  return {
    statusCode: 200,
    headers: { 'Content-Type': 'text/plain' },
    body: 'Completed evecution'
  };
}

export const handler = async function(event: any) {
  // Get the current time
  let now = new Date();
  let currentHour = now.getHours();

  console.log('Current Time: ', now);

  // If it's the weekend then leave the instance as is
  const day = getDayString(now.getDay());
  if (day === 'Saturday' || day === 'Sunday') {
    return ok();
  }

  // Get the instance schedule
  const schedule = getSchedule();

  // Get the desired state
  const desiredStateOrUndefined = schedule.find(
    ({ time }) => time === currentHour
  );

  let desiredState = 'OFF';
  if (desiredStateOrUndefined !== undefined) {
    desiredState = desiredStateOrUndefined.state;
  }

  try {
    // Get the state of the server
    let instances = await EC2.describeInstances({
      Filters: [{ Name: 'tag:Name', Values: ['MC Server'] }]
    }).promise();

    const instanceState = getInstanceState(instances);

    if (instanceState !== undefined) {
      // if the instance is on and supposed to be off
      if (instanceState.state === 'ON' && desiredState === 'OFF') {
        console.log('Stopping instance');
        // Turn if off
        await EC2.stopInstances({
          InstanceIds: [instanceState.instanceName]
        }).promise();
      }

      // if the instance is off and supposed to be on
      if (instanceState.state === 'OFF' && desiredState === 'ON') {
        console.log('Starting instance');
        // Turn it on
        await EC2.startInstances({
          InstanceIds: [instanceState.instanceName]
        }).promise();
      }
    } else {
      console.log('Unable to find instance');
    }
  } catch (err) {
    console.error(`Server error occured ${err}`);

    return {
      statusCode: 500,
      headers: { 'Content-Type': 'text/plain' },
      body: `Server error occured: ${err}`
    };
  }

  return ok();
};

/**
 * Convert a day number into the name of the day
 * @param day Must come from Date::getDay()
 */
function getDayString(day: number) {
  const days = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];
  return days[day];
}

function getSchedule(): StateAtTime[] {
  return [
    { time: 0, state: 'OFF' },
    { time: 1, state: 'OFF' },
    { time: 2, state: 'OFF' },
    { time: 3, state: 'OFF' },
    { time: 4, state: 'OFF' },
    { time: 5, state: 'OFF' },
    { time: 6, state: 'OFF' },
    { time: 7, state: 'OFF' },
    { time: 8, state: 'OFF' },
    { time: 9, state: 'OFF' },
    { time: 10, state: 'OFF' },
    { time: 11, state: 'OFF' },
    { time: 12, state: 'OFF' },
    { time: 13, state: 'OFF' },
    { time: 14, state: 'OFF' },
    { time: 15, state: 'OFF' },
    { time: 16, state: 'ON' },
    { time: 17, state: 'ON' },
    { time: 18, state: 'ON' },
    { time: 19, state: 'ON' },
    { time: 20, state: 'ON' },
    { time: 21, state: 'ON' },
    { time: 22, state: 'ON' },
    { time: 23, state: 'OFF' }
  ];
}

function getInstanceState(
  instanceDescription: aws.EC2.DescribeInstancesResult
): { state: State; instanceName: string } | undefined {
  // If the reservation isn't undefined loop through each one
  if (instanceDescription.Reservations) {
    const { Reservations } = instanceDescription;
    for (const reservation of Reservations) {
      // If the instances isn't undefined loop through each one
      if (reservation.Instances) {
        const { Instances } = reservation;

        for (const instance of Instances) {
          if (
            instance.Tags &&
            instance.Tags.find(
              ({ Key, Value }) => Key === 'Name' && Value === 'MC Server'
            ) &&
            instance.State &&
            instance.State.Name &&
            instance.InstanceId
          ) {
            const instanceName = instance.InstanceId;
            const state = instance.State.Name as InstanceState;

            switch (state) {
              case 'pending':
              case 'running':
                return { state: 'ON', instanceName };
              default:
                return { state: 'OFF', instanceName };
            }
          }
        }
      }
    }
  }
  return undefined;
}
