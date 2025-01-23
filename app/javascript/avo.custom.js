import CourseResourceController from 'controllers/course_controller'
import NestedForm from 'stimulus-rails-nested-form'
import { MarksmithController } from '@avo-hq/marksmith'

// Hook into the stimulus instance provided by Avo
const application = window.Stimulus
application.register('course-resource', CourseResourceController)
application.register('nested-form', NestedForm)
application.register('marksmith', MarksmithController)

// eslint-disable-next-line no-console
console.log('Hi from Avo custom JS 👋')
