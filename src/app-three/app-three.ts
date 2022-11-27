import { Application, Router } from 'oak/mod.ts';
import { errorHandlerMiddleware } from '../middlewares/error-handler.middleware.ts';
import { logResponseTimeMiddleware, setXResponseTimeMiddleware } from '../middlewares/x-response-time.middleware.ts';

const dogs = new Map();
dogs
  .set('1', {
    name: 'Luna',
    gender: 'female',
    age: 2,
  })
  .set('2', {
    name: 'Milo',
    gender: 'male',
    age: 1,
  })
  .set('3', {
    name: 'Coco',
    gender: 'female',
    age: 1,
  });

const router = new Router();
router
  .get('/dogs', (context) => {
    context.response.body = Array.from(dogs.values());
  })
  .get('/dogs/:id', (context) => {
    const id = context?.params?.id;
    if (dogs.has(id)) {
      context.response.body = dogs.get(id);
      return;
    }

    context.response.status = 404;
    context.response.body = { message: 'Not Found' };
  });

const app = new Application();
app.addEventListener('listen', () => {
  console.log(`[Ready] App-Three`)
})

app.use(logResponseTimeMiddleware);
app.use(setXResponseTimeMiddleware);
app.use(errorHandlerMiddleware('Three'));
app.use(router.routes());
app.use(router.allowedMethods());

export { app };
