import { config as loadEnv } from 'dotenv/mod.ts';

import { app as AppAuth } from './src/app-auth/app-auth.ts';
import { apps as AppOneLB } from './src/app-one/app-one.ts';
import { app as AppTwo } from './src/app-two/app-two.ts';
import { app as AppThree } from './src/app-three/app-three.ts';
import { app as AppFour } from './src/app-four/app-four.ts';

await loadEnv({
  export: true,
  allowEmptyValues: true,
});

await Promise.all([
  AppOneLB[0].listen({ port: 3001 }),
  AppOneLB[1].listen({ port: 3011 }),
  AppTwo.listen({ port: 3002 }),
  AppThree.listen({ port: 3003 }),
  AppFour.listen({ port: 3004 }),
  AppAuth.listen({ port: 3005 }),
]);
