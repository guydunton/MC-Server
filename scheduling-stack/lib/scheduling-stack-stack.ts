import { Stack, Construct, StackProps } from "@aws-cdk/core";
import * as lambda from "@aws-cdk/aws-lambda";
import * as iam from "@aws-cdk/aws-iam";

export class SchedulingStackStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    // The code that defines your stack goes here
    const schedulingFunction = new lambda.Function(this, "SchedulingHandler", {
      runtime: lambda.Runtime.NODEJS_10_X,
      code: lambda.Code.asset("build/src"),
      handler: "app.handler"
    });

    schedulingFunction.addToRolePolicy(
      new iam.PolicyStatement({
        effect: iam.Effect.ALLOW,
        actions: ["ec2:StartInstances", "ec2:StopInstances"],
        resources: ["*"]
      })
    );
  }
}
