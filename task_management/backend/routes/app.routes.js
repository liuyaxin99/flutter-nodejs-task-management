const tasksController = require("../controllers/tasks.controller");
const express = require("express");
const router = express.Router();

router.post("/tasks", tasksController.create);
router.get("/tasks", tasksController.findAll);
router.get("/tasks/:id", tasksController.findOne);
router.put("/tasks/:id", tasksController.updateOne);
router.delete("/tasks/:id", tasksController.deleteOne);

module.exports = router;