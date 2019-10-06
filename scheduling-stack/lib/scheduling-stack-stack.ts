import { Stack, Construct, StackProps, Duration } from "@aws-cdk/core";
import * as lambda from "@aws-cdk/aws-lambda";
import * as iam from "@aws-cdk/aws-iam";
import events = require("@aws-cdk/aws-events");
import targets = require("@aws-cdk/aws-events-targets");

export class SchedulingStackStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    const schedulingFunction = new lambda.Function(this, "SchedulingHandler", {
      runtime: lambda.Runtime.NODEJS_10_X,
      code: lambda.Code.asset("build/src"),
      handler: "app.handler"
    });

    schedulingFunction.addToRolePolicy(
      new iam.PolicyStatement({
        effect: iam.Effect.ALLOW,
        actions: [
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:DescribeInstances"
        ],
        resources: ["*"]
      })
    );

    const rule = new events.Rule(this, "rule", {
      schedule: events.Schedule.rate(Duration.minutes(10))
    });

    rule.addTarget(new targets.LambdaFunction(schedulingFunction));
  }
}
