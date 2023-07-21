const taskServices = require("../services/tasks.services");

exports.create = (req, res, next) => {
    var model = {
        taskQC: req.body.taskQC,
        taskActivity: req.body.taskActivity,
        taskCriteria: req.body.taskCriteria,
        taskStatus: req.body.taskStatus,
        taskRemark: req.body.taskRemark
    };

    taskServices.createTask(model, (error, results) => {
        if (error) {
            return next(error);
        }
        return res.status(200).send({
            message: "Success",
            data: results,
        });
    });
};

exports.findAll = (req, res, next) => {
    var model = {
        taskCriteria: req.query.taskCriteria,
    };

    taskServices.getTasks(model, (error, results) => {
        if (error) {
            return next(error);
        }
        return res.status(200).send({
            message: "Success",
            data: results,
        });
    });
};


exports.findOne = (req, res, next) => {
    var model = {
        taskId: req.params.id,
    };

    taskServices.getTaskById(model, (error, results) => {
        if (error) {
            return next(error);
        }
        return res.status(200).send({
            message: "Success",
            data: results,
        });
    });
};

exports.updateOne = (req, res, next) => {
    var model = {
        taskId: req.params.id,
        taskQC: req.body.taskQC,
        taskActivity: req.body.taskActivity,
        taskCriteria: req.body.taskCriteria,
        taskStatus: req.body.taskStatus,
        taskRemark: req.body.taskRemark
    };


    console.log(model);

    taskServices.updateTask(model, (error, results) => {
        if (error) {
            return next(error);
        }
        return res.status(200).send({
            message: "Success",
            data: results,
        });
    });
};

exports.deleteOne = (req, res, next) => {
    var model = {
        taskId: req.params.id,
    };

    taskServices.deleteTask(model, (error, results) => {
        if (error) {
            return next(error);
        }
        return res.status(200).send({
            message: "Success",
            data: results,
        });
    });
};