const mongoose = require("mongoose");

const task = mongoose.model(
    "tasks",
    mongoose.Schema(
        {
            taskQC: String,
            taskActivity: String,
            taskCriteria: String,
            taskStatus: String,
            taskRemark: String
        },
        { timestamps: true }
    )
);

module.exports = {
    task,
};