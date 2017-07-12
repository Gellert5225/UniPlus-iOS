'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.setLogger = setLogger;
exports.getLogger = getLogger;
var logger = void 0;

function setLogger(aLogger) {
  logger = aLogger;
}

function getLogger() {
  return logger;
}

// for: `import logger from './logger'`
Object.defineProperty(module.exports, 'default', {
  get: getLogger
});

// for: `import { logger } from './logger'`
Object.defineProperty(module.exports, 'logger', {
  get: getLogger
});