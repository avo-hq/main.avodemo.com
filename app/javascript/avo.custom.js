import CourseResourceController from 'controllers/course_controller'
import NestedForm from 'stimulus-rails-nested-form'

// Hook into the stimulus instance provided by Avo
const application = window.Stimulus
application.register('course-resource', CourseResourceController)
application.register('nested-form', NestedForm)

// eslint-disable-next-line no-console
console.log('Hi from Avo custom JS 👋')
