#!/usr/bin/env node
import 'source-map-support/register';
import cdk = require('@aws-cdk/core');
import { SchedulingStackStack } from '../lib/scheduling-stack-stack';

const app = new cdk.App();
new SchedulingStackStack(app, 'SchedulingStackStack');
