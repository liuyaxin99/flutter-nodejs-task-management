const { task } = require("../models/tasks.model");

async function createTask(params, callback) {
    const taskModel = new task(params);
    taskModel
        .save()
        .then((response) => {
            return callback(null, response);
        })
        .catch((error) => {
            return callback(error);
        });
}

async function getTasks(params, callback) {
    const taskCriteria = params.taskCriteria;
    var condition = taskCriteria
        ? { taskCriteria: { $regex: new RegExp(taskCriteria), $options: "i" } }
        : {};
    task
        .find(condition)
        .then((response) => {
            return callback(null, response);
        })
        .catch((error) => {
            return callback(error);
        });
}

async function getTaskById(params, callback) {
    const taskId = params.taskId;

    task
        .findById(taskId)
        .then((response) => {
            if (!response) callback("Not found Task with id " + productId);
            else callback(null, response);
        })
        .catch((error) => {
            return callback(error);
        });
}

async function updateTask(params, callback) {
    const taskId = params.taskId;

    task
        .findByIdAndUpdate(taskId, params, { useFindAndModify: false })
        .then((response) => {
            if (!response) callback("Invalid ID");
            else callback(null, response);
        })
        .catch((error) => {
            return callback(error);
        });
}

async function deleteTask(params, callback) {
    const taskId = params.taskId;

    task
        .findByIdAndRemove(taskId)
        .then((response) => {
            if (!response) callback("Invalid ID");
            else callback(null, response);
        })
        .catch((error) => {
            return callback(error);
        });
}

module.exports = {
    createTask,
    getTasks,
    getTaskById,
    updateTask,
    deleteTask
};