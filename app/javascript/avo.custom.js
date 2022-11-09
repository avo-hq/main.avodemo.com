import CourseResourceController from './controllers/course_controller'

// Hook into the stimulus instance provided by Avo
const application = window.Stimulus
application.register('course-resource', CourseResourceController)

// eslint-disable-next-line no-console
console.log('Hi from Avo custom JS 👋')
