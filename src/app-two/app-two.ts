import { Application, Router } from 'oak/mod.ts';
import { errorHandlerMiddleware } from '../middlewares/error-handler.middleware.ts';
import { logResponseTimeMiddleware, setXResponseTimeMiddleware } from '../middlewares/x-response-time.middleware.ts';

const cats = new Map();
cats
  .set('1', {
    name: 'Maggie',
    gender: 'female',
    type: 'persian',
  })
  .set('2', {
    name: 'Bubble',
    gender: 'male',
    type: 'aegean',
  })
  .set('3', {
    name: 'Abby',
    gender: 'male',
    type: 'balinese',
  });

const router = new Router();
router
  .get('/cats', (context) => {
    context.response.body = Array.from(cats.values());
  })
  .get('/cats/:id', (context) => {
    const id = context?.params?.id;
    if (cats.has(id)) {
      context.response.body = cats.get(id);
      return;
    }

    context.response.status = 404;
    context.response.body = { message: 'Not Found' };
  });

const app = new Application();
app.addEventListener('listen', () => {
  console.log(`[Ready] App-Two`)
})

app.use(logResponseTimeMiddleware);
app.use(setXResponseTimeMiddleware);
app.use(errorHandlerMiddleware('Two'));
app.use(router.routes());
app.use(router.allowedMethods());

export { app };
